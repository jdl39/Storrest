class Node < ActiveRecord::Base
  NUM_CHILDREN_NEEDED = 5
  NUM_RATINGS_NEEDED = 5

  belongs_to :parent_story, :class_name => "Story", :foreign_key => "parent_story_id"
  belongs_to :parent_node, :class_name => "Node", :foreign_key => "parent_node_id"
  has_one :story
  has_many :children, :class_name => "Node", :foreign_key => "parent_node_id"
  has_many :ratings

  def render_to_text_after_node(node)
    if self.parent_node == node
      return self.text
    else
      return self.parent_node.render_to_text_after_node(node) + " " + self.text
    end
  end

  def render_to_text
    render_to_text_after_node(nil)
  end

  def youngest_common_ancestor(other_node)
    nodes = [self, other_node]
    until nodes[0].id == nodes[1].id
      oldest_node_index = nodes[0].created_at > nodes[1].created_at ? 0 : 1
      nodes[oldest_node_index] = nodes[oldest_node_index].parent_node
      if nodes[oldest_node_index].nil? # They have no common ancestor...
        return nil
      end
    end
    return nodes[0]
  end

end
