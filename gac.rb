require 'rest-client'
require 'sinatra'

GAC_COLLECTION_SIZE = 16000

def gac_url(id)
  "http://www.gac.culture.gov.uk/gacdb/images/Large/#{id}.jpg"
end

def random_gac_id
  Random.rand(GAC_COLLECTION_SIZE)
end

def random_gac_picture
  url = nil

  loop do
    url = gac_url(random_gac_id)

    begin
      RestClient.get(url)
    rescue RestClient::NotFound
      next
    end

    break
  end

  url
end

get '/' do
  image_url = random_gac_picture
  # image_url = "http://www.gac.culture.gov.uk/gacdb/images/Large/13542.jpg"
  erb :index, locals: { image_url: image_url }
end
