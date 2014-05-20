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

	def survey_question_summaries
		["Q1 s",
		"Q2 s",
		"Q3 s",
		"Q4 s"]
	end
end
