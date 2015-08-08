class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy                          
  has_many :followed_users, through: :relationships, source: :followed                                 
  has_many :followers, through: :reverse_relationships, source: :follower
  
    # 他のユーザーをフォローする
   def follow(other_user)
     following_relationships.create(followed_id: other_user.id)
   end
  
  # def follow!(other_user)
    # relationships.create!(followed_id: other_user.id)
  # end
  
  # def unfollow!(other_user)
   # relationships.find_by(followed_id: other_user.id).destroy
  # end
  
  # フォローしているユーザーをアンフォローする
   def unfollow(other_user)
     following_relationships.find_by(followed_id: other_user.id).destroy
   end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    # relationships.find_by(followed_id: other_user.id)
    following_users.include?(other_user)
  end
end
