class ContributionController < ApplicationController

	NUM_CHILDREN_NEEDED = 5
	NUM_RATINGS_NEEDED = 5

	# TODO: Make a way to skip directly to rating if a writing contribution has already been made.
	def contribute
		@story = Story.find(params[:story_id])
		nodes_needing_children = Node.where("parent_story_id = ? AND contributions_completed = ?", @story.id, false)
		@assigned_node = node_to_assign_for_writing(nodes_needing_children)
		if not assigned_node.nil?
			# Contribute writing to the assigned node.
			@story_text = assigned_node.render_to_text
			# TODO: Render the writing view.
		else
			# Contribute rating
			nodes_needing_ratings = Node.where("parent_story_id = ? AND ratings_completed = ?", @story.id, false)
			@assigned_nodes = nodes_to_assign_for_rating(nodes_needing_ratings)
			if @assigned_nodes[0].nil? or @assigned_nodes[1].nil?
				# TODO: They've contributed as much as possible! Give them a pat on the back.
			else
				@story_texts = [assigned_nodes[0].render_to_text, assigned_nodes[1].render_to_text]
				# TODO: Render the rating view.
			end
		end
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
				for child in node.nodes do
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
					if node.nodes.length < to_return.nodes.length
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
