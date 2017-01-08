require 'sinatra' 
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/flash'

set :database, "sqlite3:twitter.sqlite3"
set :sessions, true
enable :sessions

require './models'


########## Sign In #########################
get '/' do 
	session[:user_id] = nil
 	erb :sign_in	
end

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do   
	@user = User.where(email: params[:email]).first  
	if @user && @user.password == params[:password]     
		session[:user_id] = @user.id     
		redirect '/user_home'   
	else     
		flash[:alert] = "log in failed, invalid username or password, please try again"   
		redirect '/sign_in'
	end   
end

############ Create Account #####################
get '/create_account' do
	session[:user_id] = nil
	erb :create_account
end

post '/create_account' do
	puts "THESE ARE THE PARAMS: #{params.inspect}"
	if User.where(email: params[:email]).first
		flash[:alert] = "Email Already In Use"
		redirect '/create_account'
	else
		#@user = User.create(fname: params[:fname], lname: params[:lname], email: params[:email], password: params[:password])
		@user = User.create(params) #short way of doing the line above, does the same thing
		session[:user_id] = @user.id
		flash[:notice] = "You were successfully logged in!"
		erb :user_home
	end
end

########### Sign Out ##########

get '/sign-out' do
	session[:user_id] = nil 
	redirect '/' 
end

########### User's Home Page ########################
get '/user_home' do
	@user = current_user
	@posts = @user.posts.all
	erb :user_home
end

get '/all_posts' do
	@posts = Post.all
	erb :all_posts
end

########### Edit and Delete Profile ########################

# get '/profile' do
# 	@user = current_user
# 	erb :profile
# end

get '/edit' do
	@user = current_user
	erb :edit_profile
end

post '/edit' do
	current_user.update_attributes(params)
	redirect '/user_home'
end

get '/delete_user' do
	current_user.destroy
	redirect '/'
end

get '/all_users' do
	@user = User.all
	erb :all_users
end

get '/user/:id' do
	@user = User.find(params[:id])
	@posts = @user.posts.all
	erb :user
end	

############ Posts #####################
get '/new_post' do
 	erb :new_post
end
# get '/edit_post/:post_id' do #does not find the path
# 	Post.find(params[:post_id])
# 	erb :edit_post
# end

post '/new_post/' do
	@user = current_user
 	@posts = @user.posts.create(title: params[:title], message: params[:message], user_id: current_user.id)
 	redirect '/user_home'
end
# post '/edit_post/:post_id' do
# 	@post = Post.find(params[:post_id])
# 	@post.update_attributes(params[:post])
# 	erb :user_home
# end

###################################
def current_user
	if session[:user_id]
		User.find(session[:user_id])
	end
end
