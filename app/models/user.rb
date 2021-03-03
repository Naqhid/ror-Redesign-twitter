class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :fullname, presence: true, length: { minimum: 5, maximum: 20 }

  has_many :opinions, foreign_key: 'author_id'
  has_many :likes, dependent: :destroy

  has_many :followings, foreign_key: 'follower_id'
  has_many :following_users, through: :followings, source: :inverse_user

  has_many :followers, foreign_key: 'followed_id', class_name: 'Following'
  has_many :follower_users, through: :followers, source: :user

  has_one_attached :photo
  has_one_attached :coverimage

  def follower?(current_user, user)
    current_user.following_users.ids.include?(user)
  end

  def followings_and_own_tweets
    Opinion.where(user: following_users).or(Opinion.where(user: self)).ordered_by_created_at
  end
end
