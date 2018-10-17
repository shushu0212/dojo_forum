class AddPublishToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :publish, :boolean, :default => true
  end
end
