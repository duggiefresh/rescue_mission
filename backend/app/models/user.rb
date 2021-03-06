class User < ActiveRecord::Base
  has_many :api_keys, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :username, presence: true, uniqueness: true

  def self.find_or_create_from_oauth!(oauth)
    find_by(uid: oauth.uid, provider: oauth.provider) || create_from_oauth!(oauth)
  end

  def self.create_from_oauth!(oauth)
    create!(attributes_from_oauth(oauth))
  end

  def self.attributes_from_oauth(oauth)
    {
      email: oauth.email,
      provider: oauth.provider,
      uid: oauth.uid,
      username: oauth.username
    }
  end
end
