class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController


  def facebook
    handle_omniauth :facebook
  end

  def twitter
    handle_omniauth :twitter
  end


  def extract_data provider, data
    fake_email = Faker::Internet.email(Faker::Internet.user_name + DateTime.now.strftime("%Y%m%d%H%M%S"))
    fake_pwd = Devise.friendly_token[0,20]
    if provider == :facebook
      user_params = {name: data.info.name, email: data.info.email, password: fake_pwd, has_password: false}
      image_url = data.info.image.gsub("http:","https:") + "?type=large"
    else provider == :twitter
      user_params = {name: data.info.name, email: fake_email , password: fake_pwd, has_password: false, has_email: false}
      image_url = data.info.image.gsub("http:","https:").gsub("normal","400x400")
    end
    return user_params, image_url
  end

  def handle_omniauth provider
    oauth_data = request.env["omniauth.auth"]
    @user = current_user || User.from_omniauth(oauth_data)

    if user_signed_in? #Linking account
      @user.unlink_provider oauth_data["provider"]
      @user.link_oauth oauth_data
      redirect_to edit_user_registration_path
    elsif @user && @user.persisted? #Login
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    else #Registration
      user_params, image_url = extract_data(provider, oauth_data)
      @user = User.new(user_params)
      @user.save!
      save_avatar @user, image_url
      @user.link_oauth oauth_data
      sign_in @user
      redirect_to notice_groups_path
    end
  end

  def save_avatar user, image_url
    media = Media.new
    media.remote_image_url = image_url
    media.media_owner = user 
    media.save!
    
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

  protected



  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
