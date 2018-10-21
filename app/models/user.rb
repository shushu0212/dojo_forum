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

  def admin?
    self.role.name == "Admin"
  end
end
