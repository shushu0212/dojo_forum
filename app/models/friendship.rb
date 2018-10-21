class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friending, class_name: "User" 
end
