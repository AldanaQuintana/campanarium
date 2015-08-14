module PageHelper
  def login!(user)
    visit('/')

    find('#user_email_login').set(user.email)
    find('#user_password_login').set(user.password)

    click_button 'Ingresar'
  end

  def response
    page.status_code
  end
end