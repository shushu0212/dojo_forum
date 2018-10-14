class AddLastCommentCreateAtToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :last_commnet_created_at, :datetime
  end
end
