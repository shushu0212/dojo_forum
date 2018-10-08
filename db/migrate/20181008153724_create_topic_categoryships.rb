class CreateTopicCategoryships < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_categoryships do |t|
      t.integer :topic_id
      t.integer :category_id
      t.timestamps
    end
  end
end
