require 'sinatra' 
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/flash'

set :database, "sqlite3:twitter.sqlite3"
set :sessions, true
enable :sessions

require './models'

get '/' do 
 	erb :create_account	
end
post '/create_account' do
	puts "THESE ARE THE PARAMS: #{params.inspect}"
	#@user = User.create(fname: params[:fname], lname: params[:lname], email: params[:email], password: params[:password])
	@user = User.create(params) #short way of doing the line above, does the same thing
	session[:user_id] = @user.id
	flash[:notice] = "You were successfully logged in!"
	erb :user_home
end