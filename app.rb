require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'
require 'mongo'
require 'json/ext'

include Mongo

configure do
  conn = MongoClient.new("localhost", 27017)
  set :mongo_connection, conn
  set :mongo_db, conn.db('mydb')
end

configure do
  enable :sessions
end

get '/' do
  erb :index
end

get '/about' do
  erb :aboutus
end

get '/privacy' do
  erb :privacy
end


get '/search' do
  @section_height = "50%"
  @para_beach = params["beach"]
  @title = params["beach"].split(" ").join("|")
  col = settings.mongo_db["beach"]
  # tmp = col.find({"name" => Regexp.new(@title)})
  @beachs = col.find({:description => /(#{@title})/im},{:limit => 15}).to_a
  if @beachs.length ==0
    @beachs = col.find({},{:limit => 15}).to_a
  end
  erb :search
end

get '/beach/:id' do
  @section_height = "50%"
  @beach = JSON.parse(settings.mongo_db["beach"].find_one(:_id => BSON::ObjectId(params[:id])).to_json)
  @title = @beach["name"]
  erb :beach
end
