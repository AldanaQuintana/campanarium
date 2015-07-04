class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :user_oauths

  def self.from_omniauth omniauth
    User.joins(:user_oauths).where(user_oauths: omniauth.slice(:provider, :uid)).readonly(false).first
  end

  def link_oauth oauth_data
    UserOauth.create!(uid: oauth_data["uid"], provider: oauth_data["provider"], user: self)
  end

  def unlink_provider provider
    has_oauth?(provider).try(:destroy)
  end

  def has_oauth? provider
    user_oauths.where(provider: provider).first
  end

  def has_password?
    has_password
  end

  def password_required?
    false #has_password? && super
  end

  def has_many_oauths?
    user_oauths.count > 1
  end

end
