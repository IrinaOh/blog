require 'sinatra' 
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/flash'

set :database, "sqlite3:twitter.sqlite3"
set :sessions, true
enable :sessions

require './models'

###################################
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

###################################
get '/home' do
	@user = current_user
	erb :user_home
end

###################################

def current_user
	if session[:user_id]
		User.find(session[:user_id])
	end
end

###################################

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do   
	@user = User.where(email: params[:email]).first   
	if @user && @user.password == params[:password]     
		session[:user_id] = @user.id     
		flash[:sign_in] = "You're successfully logged in"## this is not doing anything at the moment!!:(#
		erb :user_home   
	else     
		flash[:alert] = "log in failed, please try again"   
		redirect '/sign_in'
	end   
end

get '/sign-out' do
	session[:user_id] = nil 
	erb :sign_in 
end

#################################
get '/profile' do
	@user = current_user
	erb :profile
end

get '/edit' do
	@user = current_user
	erb :edit_profile
end

post '/edit' do
	current_user.update_attributes(params)
	redirect '/profile'
end

get '/delete_user' do
	current_user.destroy
	redirect '/'
end

#################################





