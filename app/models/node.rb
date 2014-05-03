class Node < ActiveRecord::Base
  belongs_to :parent_story, :class_name => "Story", :foreign_key => "parent_story_id"
  belongs_to :parent_node, :class_name => "Node", :foreign_key => "parent_node_id"
  has_one :story
  has_many :nodes
  has_many :ratings

  def render_to_text
  	if self.parent_node.nil?
  		return self.text
  	else
  		return self.parent_node.render_to_text + " " + self.text
  	end
  end

  def children
    return Node.where(parent_node: self)

  end

end
