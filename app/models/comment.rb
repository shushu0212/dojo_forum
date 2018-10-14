class Comment < ApplicationRecord
  belongs_to :user, counter_cache: :comments_count
  belongs_to :topic, counter_cache: :comments_count
end
