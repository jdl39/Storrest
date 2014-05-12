module ContributionHelper
	def current_contributor
		if cookies[:contributor_id].nil?
			cookies.permanent[:contributor_id] = SecureRandom.urlsafe_base64
		end
		return cookies[:contributor_id]
	end
end
