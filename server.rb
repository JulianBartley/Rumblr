require "sinatra/activerecord"
require "sinatra"
require "sinatra/flash"
require "./models"

set :database, {adapter: "sqlite3", database: "Rumblr.sqlite3"}
enable :sessions

class User < ActiveRecord::Base
end
class Post < ActiveRecord::Base
end

get "/" do
  erb :home

end

get "/signup" do
  @user = User.new
  erb :signup
end

post "/signup" do
  @user = User.new(params[:user])
  if @user.save
    p "#{@user.first_name} is now in Rumblr."
    redirect %(/profile/#{@user.id})
  end
    erb :home
end

get "/login" do

     erb :login
end

post '/login' do
    @user = User.find_by(email: params[:email])
    given_password = params[:password]
    if @user.password == given_password
        session[:user_id] = @user.id
        redirect %(/social/#{@user.id})
      end
end

get '/social/:id' do
  @user = User.find(params[:id])
  erb :social
rescue ActiveRecord::RecordNotFound
  puts "error14"
  erb :home
end

post '/logout' do 
  session.clear
  p "User Logged out Successfully"
  redirect '/login'
end 