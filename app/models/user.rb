class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :topics
  has_many :comments, dependent: :destroy
  belongs_to :role

  def admin?
    self.role.name == "Admin"
  end
end
