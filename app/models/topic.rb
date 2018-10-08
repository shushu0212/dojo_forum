class Topic < ApplicationRecord
  belongs_to :user, counter_cache: :topics_count
  belongs_to :category
  has_many :comments, dependent: :destroy
end
