require 'nokogiri'
require 'thread'
require 'uri'

Picture = Struct.new(:title, :artist, :date, :image_url, :page_url)

LOG = Logger.new(STDOUT)

Thread.abort_on_exception = true

module GACRandomPicture
  def self.fetch
    loop do
      id = Random.rand(30000)
      url = "http://www.gac.culture.gov.uk/gacdb/search.php?mode=show&id=#{id}"

      LOG.info "Trying: #{url}"

      begin
        html   = RestClient.get(url).body

        next if html.include? '[maker_name]'

        parsed = Nokogiri::HTML(html)

        larger_image_link = parsed.css('#zoomImageLarge').first
        image_url = URI.join(url, larger_image_link['href'])
        RestClient.get(image_url.to_s)

        LOG.info "Success: #{url} | Found larger image link | Proceeding"

        artist = parsed.css('#detailsArtWork tr:nth-child(1) .cell2').text
        title  = parsed.css('#detailsArtWork tr:nth-child(2) .cell2').text
        date   = parsed.css('#detailsArtWork tr:nth-child(3) .cell2').text

        return Picture.new(
          title,
          artist,
          date,
          image_url,
          url
        )
      rescue RestClient::NotFound
        next
      end
    end
  end
end

class GACPicture
  def initialize(val)
    @val   = val
    @mutex = Mutex.new
  end

  def val
    @mutex.synchronize { @val }
  end

  def val=(new_val)
    @mutex.synchronize { @val = new_val }
    nil
  end
end

class GACPictureUpdater
  def initialize(gac_picture, sleep_time=60)
    @gac_picture = gac_picture
    @sleep_time  = sleep_time
    self
  end

  def start
    @thread = Thread.new do
      loop do
        sleep @sleep_time
        @gac_picture.val = GACRandomPicture.fetch
      end
    end
    self
  end
end
