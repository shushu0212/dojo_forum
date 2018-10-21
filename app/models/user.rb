class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :topics
  has_many :comments, dependent: :destroy
  belongs_to :role

  has_many :collects, dependent: :destroy
  has_many :collected_topics, through: :collects, source: :topic

  # 設定friend關係
  has_many :friendships, dependent: :destroy
  has_many :friendings, through: :friendships

  # 設定inverse_friend關係(被加入朋友)
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friending_id"
  has_many :frienders, through: :inverse_friendships, source: :user

  def admin?
    self.role.name == "Admin"
  end

  def sent_friend_invitation?(user)
    self.friendings.include?(user)
  end

  def friended?(user)
    user.friendings.include?(self)
  end
end
