class Node < ActiveRecord::Base
  belongs_to :parent_story, :class_name => "Story", :foreign_key => "parent_story_id"
  belongs_to :parent_node, :class_name => "Node", :foreign_key => "parent_node_id"
  has_one :story
  has_many :nodes
end
