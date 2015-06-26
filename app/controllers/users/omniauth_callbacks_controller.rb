class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:


  def facebook
    handle_omniauth :facebook
  end

  def twitter
    handle_omniauth :twitter
  end


  def extract_data provider, data  
    if provider == :facebook
      {name: data.info.name, email: data.info.email, password: Devise.friendly_token[0,20]}
    else provider == :twitter 
      {name: data.info.name, email: "twitter.no.me.da.el@email.com", password: Devise.friendly_token[0,20]}
    end
  end

  def handle_omniauth provider
    oauth_data = request.env["omniauth.auth"]
    @user = User.from_omniauth(oauth_data)

    if @user && @user.persisted?
      sign_in_and_redirect @user, :event => :authentication 
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    else
      @user = User.new(extract_data(provider, oauth_data))
      @user.save!
      UserOauth.create!(uid: oauth_data["uid"], provider: oauth_data["provider"], user: @user)
      sign_in_and_redirect @user, :event => :authentication 
    end
  end

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
