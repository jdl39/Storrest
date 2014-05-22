module ContributionHelper
	def current_contributor
		if cookies[:contributor_id].nil?
			cookies.permanent[:contributor_id] = SecureRandom.urlsafe_base64
		end
		return cookies[:contributor_id]
	end

	def survey_questions
		["How much does it make you feel something?",
		"How well-written is it?",
		"How well does it fit with the rest of the story or advance the plot?",
		"How much do you like it overall?"]
	end

	def survey_question_summaries
		["Emotional",
		"Style",
		"Cohesion/Plot",
		"Overall"]
	end
end
