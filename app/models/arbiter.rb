class Arbiter < ActiveRecord::Base
	has_many :stories
	has_secure_password

	validates :username, presence: true, uniqueness: true

	before_create :create_remember_token

	def Arbiter.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def Arbiter.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	private
		def create_remember_token
			self.remember_token = Arbiter.digest(Arbiter.new_remember_token)
		end
end
