require 'sinatra'

require_relative 'gac'

PICTURE = GACPicture.new(GACRandomPicture.fetch)
UPDATER = GACPictureUpdater.new(PICTURE, 30).start

get '/' do
  erb :index, locals: { picture: PICTURE.val }
end
