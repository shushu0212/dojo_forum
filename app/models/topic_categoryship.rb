class TopicCategoryship < ApplicationRecord
  # set many topics to many categories
  belongs_to :topic
  belongs_to :category
end
