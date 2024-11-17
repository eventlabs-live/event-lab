class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true,
            uniqueness: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
                      message: "must be a valid email address" }
  has_many :event_registrations

  has_many :active_relationships, class_name: "Follower",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Follower",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

end
