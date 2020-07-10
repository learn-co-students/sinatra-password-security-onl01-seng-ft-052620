require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	# renders an index.erb file with links to signup or login
	get "/" do
		erb :index
	end

	# renders a form to create a new user. The form includes fields for username and password.
	get "/signup" do
		erb :signup
	end

	# make a new instance of our user class with a username and password from params.
	post "/signup" do
		#your code here!
		user = User.new(:username => params[:username], :password => params[:password])

		if user.save
			redirect "/login"
		else
			redirect "/failure"
		end
	end

	# renders a form for logging in
	get "/login" do
		erb :login
	end

	post "/login" do
		#your code here!
		user = User.find_by(:username => params[:username])

		#Next, we need to check, did we find a user with that username? This can be written as user != nil or simply user.
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect "/success"
		else
			redirect "/failure"
		end
	end

	# renders a success.erb page, which should be displayed once a user successfully logs in.
	get "/success" do
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	# renders a failure.erb page. This will be accessed if there is an error logging in or signing up.
	get "/failure" do
		erb :failure
	end

	# clears the session data and redirects to the homepage.
	get "/logout" do
		session.clear
		redirect "/"
	end

	helpers do
		# returns true or false based on the presence of a session[:user_id]
		def logged_in?
			!!session[:user_id]
		end

		# returns the instance of the logged in user, based on the session[:user_id]
		def current_user
			User.find(session[:user_id])
		end
	end

end
