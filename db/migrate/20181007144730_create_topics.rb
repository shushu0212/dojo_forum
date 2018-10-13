class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.integer :comments_count, default: 0
      t.integer :viewed_count, default: 0
      t.timestamps
    end
  end
end
