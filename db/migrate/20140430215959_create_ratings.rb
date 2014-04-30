class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :node, index: true
      t.integer :rating1
      t.integer :rating2
      t.integer :rating3
      t.integer :rating4
      t.string :contributor

      t.timestamps
    end
  end
end
