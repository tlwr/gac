require 'rest-client'
require 'sinatra'

require_relative 'picture'

RANDOM_GAC_PICTURE = GovernmentArtCollectionRandomPicture.new.start


get '/' do
  image_url = RANDOM_GAC_PICTURE.picture
  # image_url = "http://www.gac.culture.gov.uk/gacdb/images/Large/13542.jpg"
  erb :index, locals: { image_url: image_url }
end
