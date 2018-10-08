class Topic < ApplicationRecord
  belongs_to :user, counter_cache: :topics_count
  
  # set many topics to many categories
  has_many :topic_categoryships
  has_many :categories, :through => :topic_categoryships
  
  has_many :comments, dependent: :destroy
end
