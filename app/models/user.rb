class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :user_oauths
  
  def self.from_omniauth omniauth
    User.joins(:user_oauths).where(user_oauths: omniauth.slice(:provider, :uid)).readonly(false).first
  end

end
