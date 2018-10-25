class Topic < ApplicationRecord
  mount_uploader :image, PhotoUploader

  belongs_to :user, counter_cache: :topics_count
  belongs_to :audience
  
  # set many topics to many categories
  has_many :topic_categoryships
  has_many :categories, :through => :topic_categoryships
  
  has_many :comments, dependent: :destroy

  has_many :collects, dependent: :destroy
  has_many :collected_users, through: :collects, source: :user

  def is_collected?(user)
    self.collected_users.include?(user) 
  end

end
