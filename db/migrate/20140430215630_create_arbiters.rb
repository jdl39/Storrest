class CreateArbiters < ActiveRecord::Migration
  def change
    create_table :arbiters do |t|
      t.string :username
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
    add_index :arbiters, :username, unique: true
    add_index :arbiters, :remember_token, unique: true
  end
end
