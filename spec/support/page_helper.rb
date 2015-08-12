module PageHelper
  def login!(user)
    visit('/')

    find('#user_email').set(user.email)
    find('#user_password').set(user.password)

    click_button 'Iniciar Sesión'
  end

  def response
    page.status_code
  end
end