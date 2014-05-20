module ContributionHelper
	def current_contributor
		if cookies[:contributor_id].nil?
			cookies.permanent[:contributor_id] = SecureRandom.urlsafe_base64
		end
		return cookies[:contributor_id]
	end

	def survey_questions
		["Q1",
		"Q2",
		"Q3",
		"Q4"]
	end
end
