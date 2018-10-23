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
  has_many :friendships, -> {where accept: true}, dependent: :destroy
  has_many :friendings, through: :friendships

  # 設定friend waiting for response關係
  has_many :waiting_friendships, -> {where accept: false}, class_name: "Friendship", dependent: :destroy
  has_many :waiting_friendings, through: :waiting_friendships, source: :friending

  # 設定inverse_friend關係(被加入朋友)
  has_many :inverse_friendships, -> {where accept: true}, class_name: "Friendship", foreign_key: "friending_id"
  has_many :frienders, through: :inverse_friendships, source: :user

  # 設定inverse_friend waiting for me response關係(被加入朋友)
  has_many :inverse_waiting_friendships, -> {where accept: false}, class_name: "Friendship", foreign_key: "friending_id"
  has_many :waiting_frienders, through: :inverse_waiting_friendships, source: :user

  def admin?
    self.role.name == "Admin"
  end

  def sent_friend_invitation?(user)
    self.friendings.include?(user)
  end

  def friended?(user)
    user.friendings.include?(self)
  end

  def all_friends 
    friends = self.friendings + self.frienders
    return friends.uniq
  end
end

