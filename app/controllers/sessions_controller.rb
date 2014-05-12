class SessionsController < ApplicationController
	def new
		if signed_in?
			redirect_to controller: 'arbiter', action: 'new_story'
		end
	end

	def create
		arbiter = Arbiter.find_by(username: params[:session][:username])
		if (arbiter && arbiter.authenticate(params[:session][:password]))
			sign_in arbiter
		else
			flash[:error] = "Invalid username/password."
		end
		redirect_to action: 'new'
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end