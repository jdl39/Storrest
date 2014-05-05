class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :parent_story, index: true
      t.references :parent_node, index: true
      t.string :contributor
      t.text :text
      t.boolean :is_active #a leaf that the arbiter hasn't passed judgement on - needs to be displayed in trim
      t.boolean :contributions_completed #needs more contributions?
      t.boolean :ratings_completed #sufficient number of ratings completed?

      t.timestamps
    end
  end
end
