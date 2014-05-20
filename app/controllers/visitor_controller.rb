class VisitorController < ApplicationController

	def about
    	nodes_in_need = Node.where('contributions_completed = ? or ratings_completed = ?', false, false)
    	@stories = Set.new
    	nodes_in_need.each do |node|
      		@stories << node.parent_story
    	end

    	complete_story_nodes = Node.where('is_story_ending = ?', true)
    	@complete_stories = complete_story_nodes.map { |node| [node.completed_story_title, node.id] }
  	end

  	def view_node
  		node = Node.find(params[:id])
  		@story_title = node.is_story_ending ? node.completed_story_title : node.parent_story.title
  		@story_text = node.render_to_text
  	end
end
