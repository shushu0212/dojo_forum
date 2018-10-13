class Category < ApplicationRecord
  # set many topics to many categories
  has_many :topic_categoryships, dependent: :restrict_with_error
  has_many :topics, :through => :topic_categoryships
end
