class Story < ActiveRecord::Base
  belongs_to :arbiter
  belongs_to :root_node, :class_name => "Node", :foreign_key => "root_node_id"
end
