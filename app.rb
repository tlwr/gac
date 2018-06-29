require 'rest-client'
require 'sinatra'

require_relative 'gac'

PICTURE = GACPicture.new(GACRandomPicture.fetch)
UPDATER = GACPictureUpdater.new(PICTURE, 30).start

get '/' do
  image_url = PICTURE.url
  erb :index, locals: { image_url: image_url }
end
