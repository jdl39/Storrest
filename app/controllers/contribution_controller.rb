class ContributionController < ApplicationController

	# TODO: Make a way to skip directly to rating if a writing contribution has already been made.
	def contribute
		@story = Story.find(params[:id])
		nodes_needing_children = Node.where("parent_story_id = ? AND contributions_completed = ? AND is_active = ?", @story.id, false, false)
		@assigned_node = params[:rating] == 'true' ? nil : node_to_assign_for_writing(nodes_needing_children)
		if not @assigned_node.nil?
			# Contribute writing to the assigned node.
			@story_text = @assigned_node.render_to_text
			# Render the writing view.
			render 'write'
			return
		else
			# Contribute rating
			#nodes_needing_ratings = Node.where("parent_story_id = ? AND ratings_completed = ?", @story.id, false)
			nodes_needing_ratings = Node.where("parent_story_id = ? AND is_active = ?", @story.id, true) # This line allows for more ratings than needed.
			@assigned_nodes = nodes_to_assign_for_rating(nodes_needing_ratings)
			if @assigned_nodes[0].nil? or @assigned_nodes[1].nil?
				# They've contributed as much as possible! Give them a pat on the back.
				render 'no_more_to_contribute'
				return
			else
				common_ancestor = @assigned_nodes[0].youngest_common_ancestor(@assigned_nodes[1])
				@trunk_text = common_ancestor.nil? ? "" : common_ancestor.render_to_text
				@branch_texts = [@assigned_nodes[0].render_to_text_after_node(common_ancestor), @assigned_nodes[1].render_to_text_after_node(common_ancestor)]
				# Render the rating view.
				render 'rating'
				return
			end
		end
	end

	def post_writing
		contribution = params[:contribution]

		# Build new node.
		new_node = Node.new
		parent_node = Node.find(contribution[:parent_id])
		new_node.parent_story = parent_node.parent_story
		new_node.parent_node = parent_node
		new_node.contributor = current_contributor
		new_node.text = contribution[:text]
		new_node.is_active = true
		new_node.contributions_completed = false
		new_node.ratings_completed = false

		unless new_node.save
			# TODO: Handle save errors.
		end

		# See if we've got enough contributions.
		if parent_node.children.size >= Node::NUM_CHILDREN_NEEDED
			parent_node.contributions_completed = true
			parent_node.save
		end

		redirect_to action: 'contribute', id: parent_node.parent_story.id, rating: true
	end

	def post_rating
		rating_params = params[:rating_params]

		# Build new rating.
		new_rating1 = Rating.new
		parent_node1 = Node.find(rating_params[:node1_id])
		new_rating1.node = parent_node1
		new_rating1.rating1 = rating_params[:rating11]
		new_rating1.rating2 = rating_params[:rating12]
		new_rating1.rating3 = rating_params[:rating13]
		new_rating1.rating4 = rating_params[:rating14]
		new_rating1.contributor = current_contributor

		new_rating2 = Rating.new
		parent_node2 = Node.find(rating_params[:node2_id])
		new_rating2.node = parent_node2
		new_rating2.rating1 = rating_params[:rating21]
		new_rating2.rating2 = rating_params[:rating22]
		new_rating2.rating3 = rating_params[:rating23]
		new_rating2.rating4 = rating_params[:rating24]
		new_rating2.contributor = current_contributor

		unless new_rating1.save
			# TODO: Handle save errors.
		end
		unless new_rating2.save
			# TODO: Handle save errors.
		end
		
		# See if we've got enough ratings.
		if parent_node1.ratings.size >= Node::NUM_RATINGS_NEEDED
			parent_node1.ratings_completed = true
			parent_node1.save
		end
		if parent_node2.ratings.size >= Node::NUM_RATINGS_NEEDED
			parent_node2.ratings_completed = true
			parent_node2.save
		end

		redirect_to action: 'contribute', id: parent_node1.parent_story.id, rating: true
	end

	private
		def current_contributor
			if cookies[:contributor_id].nil?
				cookies.permanent[:contributor_id] = SecureRandom.urlsafe_base64
			end
			return cookies[:contributor_id]
		end

		def node_to_assign_for_writing(possibilities)
			to_return = nil
			for node in possibilities do
				# See if this contributor already added to this node.
				already_wrote = false
				for child in node.children do
					if node.contributor == current_contributor
						already_wrote = true
						break
					end
				end
				if already_wrote
					next
				end

				# See if this node needs contributions more than what we have so far.
				if to_return.nil?
					to_return = node
				else
					if node.children.length < to_return.children.length
						to_return = node
					end
				end
			end
			return to_return
		end

		def nodes_to_assign_for_rating(possibilities)
			node1 = nil
			node2 = nil

			for node in possibilities do

				# You can't rate your own contribution!
				if node.contributor == current_contributor
					next
				end

				# See if this contributor already rated this node.
				already_rated = (Rating.where("node_id = ? AND contributor = ?", node.id, current_contributor).length != 0)
				if already_rated
					next
				end

				# See if this node needs ratings more than another
				if node1.nil?
					node1 = node
				elsif node2.nil?
					node2 = node
				else
					# I hope this logic works. Consider simplifying. My brain must not work right now.
					if node1.ratings.length > node.ratings.length
						if node1.ratings.length > node2.ratings.length
							node1 = node
						else
							node2 = node
						end
					elsif node2.ratings.length > node.ratings.length
						node2 = node
					end
				end
			end

			return [node1, node2]
		end
end
