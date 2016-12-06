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
get '/show_logged_in' do
	@user = current_user
	erb :user_home
end
get '/sign_in' do
	erb :sign_in
end
get '/sign-out' do
	session[:user_id] = nil #sign user out
	redirect '/' #redirects user to the main page , that means I don't need to create sign-out.erb
end
post '/create_account' do
	puts "THESE ARE THE PARAMS: #{params.inspect}"
	#@user = User.create(fname: params[:fname], lname: params[:lname], email: params[:email], password: params[:password])
	@user = User.create(params) #short way of doing the line above, does the same thing
	session[:user_id] = @user.id
	flash[:notice] = "You were successfully logged in!"
	erb :user_home
end
post '/sign_in' do   
	@user = User.where(email: params[:email]).first   
	if @user && @user.password == params[:password]     
		session[:user_id] = @user.id     
		flash[:notice] = "You've been signed in successfully."   
	else     
		flash[:alert] = "There was a problem signing you in."   
	end   
	redirect "/show_logged_in" 
end
def current_user
	if session[:user_id]
		User.find(session[:user_id])
	end
end
# next line is


# next lines are for edit profile #

get '/edit' do
	@user = current_user
	erb :edit_profile
end

post '/edit' do
	current_user.update_attributes(params)
	
	redirect '/show_logged_in'
end

#################################






