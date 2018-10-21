class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friending_id
      t.boolean :accept, :default => false
      t.boolean :ignore, :default => false
      t.timestamps
    end
  end
end
