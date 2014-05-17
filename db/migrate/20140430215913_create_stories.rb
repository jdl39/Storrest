class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :arbiter, index: true
      t.references :root_node, index: true
      t.string :title
      t.boolean :complete

      t.integer :length
      t.integer :contributions_per_node
      t.integer :ratings_per_node

      t.timestamps
    end
  end
end
