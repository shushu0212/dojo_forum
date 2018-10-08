class Category < ApplicationRecord
  has_many :topics, dependent: :restrict_with_error
end
