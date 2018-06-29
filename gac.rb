require 'thread'

Thread.abort_on_exception = true

module GACRandomPicture
  def self.fetch
    loop do
      rand_id = Random.rand(16000)
      url = "http://www.gac.culture.gov.uk/gacdb/images/Large/#{rand_id}.jpg"

      begin
        RestClient.get(url)
        return url
      rescue RestClient::NotFound
        next
      end
    end
  end
end

class GACPicture
  def initialize(url)
    @url   = url
    @mutex = Mutex.new
  end

  def url
    @mutex.synchronize { @url }
  end

  def url=(new_url)
    @mutex.synchronize { @url = new_url }
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
        @gac_picture.url = GACRandomPicture.fetch
      end
    end
    self
  end
end
