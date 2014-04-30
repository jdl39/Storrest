class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :parent_story, index: true
      t.references :parent_node, index: true
      t.string :contributor
      t.text :text
      t.boolean :is_active

      t.timestamps
    end
  end
end