class Node < ActiveRecord::Base
  NUM_CHILDREN_NEEDED = 5
  NUM_RATINGS_NEEDED = 5

  belongs_to :parent_story, :class_name => "Story", :foreign_key => "parent_story_id"
  belongs_to :parent_node, :class_name => "Node", :foreign_key => "parent_node_id"
  has_one :story
  has_many :children, :class_name => "Node", :foreign_key => "parent_node_id"
  has_many :ratings

  def render_to_text
  	if self.parent_node.nil?
  		return self.text
  	else
  		return self.parent_node.render_to_text + " " + self.text
  	end
  end

  #def children
  #  return self.nodes

  #end

end
