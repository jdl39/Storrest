class CreateArbiters < ActiveRecord::Migration
  def change
    create_table :arbiters do |t|
      t.string :username
      t.string :password

      t.timestamps
    end
    add_index :arbiters, :username, unique: true
  end
end
