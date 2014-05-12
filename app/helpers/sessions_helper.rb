module SessionsHelper
	def sign_in(arbiter)
		remember_token = Arbiter.new_remember_token
    	cookies.permanent[:remember_token] = remember_token
    	arbiter.update_attribute(:remember_token, Arbiter.digest(remember_token))
    	self.current_arbiter = arbiter
	end

	def sign_out
    	if not signed_in?
      		return
    	end
    	current_arbiter.update_attribute(:remember_token,
                                  Arbiter.digest(Arbiter.new_remember_token))
    	cookies.delete(:remember_token)
    	self.current_arbiter = nil
  	end

	def signed_in?
    	!current_arbiter.nil?
  	end

	def current_arbiter=(arbiter)
    	@current_arbiter = arbiter
  	end

  	def current_arbiter
    	remember_token = Arbiter.digest(cookies[:remember_token])
    	@current_arbiter ||= Arbiter.find_by(remember_token: remember_token)
  	end
end