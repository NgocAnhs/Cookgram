class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :omniauthable, omniauth_providers: [:facebook]
  
  ## Associations
  has_one_attached :avatar

  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :active_relationships, foreign_key: :follower_id, class_name: "Relationship", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, foreign_key: :followed_id, class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  ratyrate_rater
  ##
  ## Func custom
  def username
    email.split('@')[0]
  end

  def full_name
    "#{fname} #{lname}"
  end

  def following_and_own_recipes
    my_following = active_relationships
    our_recipes = []
    my_following.each do |f|
      f.followed.recipes&.each do |r|
        our_recipes << r
      end
    end
    recipes.each do |r|
      our_recipes << r
    end
    our_recipes.sort_by(&:created_at).reverse
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.fname = auth.info.first_name # assuming the user model has a first name
    user.lname = auth.info.last_name # assuming the user model has a last name
    # user.avatar = auth.info.image # assuming the user model has an image
    user.save
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info'])
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize: "150x150!").processed
    else
      'default_avatar.jpg'
    end
  end

  private

  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'default_avatar.jpg'
          )
        ),
        filename: 'default_avatar.jpg',
        content_type: 'image/jpg'
      )
    end
  end
  ##
  ## Validates
  validates :lname, :fname, presence: true, length: { in: 2..30 }
end
