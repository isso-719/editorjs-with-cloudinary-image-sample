require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'dotenv'
require 'cloudinary'
require 'cloudinary/uploader'
require 'cloudinary/utils'
require 'securerandom'

Dotenv.load
Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUD_NAME']
  config.api_key = ENV['API_KEY']
  config.api_secret = ENV['API_SECRET']
end

get '/' do
  erb :index
end

post '/upload' do
  if params[:image]
    image = params[:image]
    image_url = Cloudinary::Uploader.upload(image[:tempfile], public_id: SecureRandom.hex)['url']
    content_type :json
    { success: 1,
      file:
        { url: image_url,
          name: image[:filename],
          size: image[:tempfile].size
        }
    }.to_json
  end
end