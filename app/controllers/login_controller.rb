class LoginController < ApplicationController
  def admin
    session.delete(:ad)
    cookies.delete(:email)
    cookies.delete(:att_tok)
  end

  def user
    session.delete(:ad)
    cookies.delete(:email)
    cookies.delete(:att_tok)
  end

  def sign_in_admin
    r = RunaApi.admin_connect(params[:email], params[:password])
    response = JSON.parse(r.body)

    respond_to do |format|
      if r.code == 200
        cookies.signed[:email] = params[:email]
        cookies.signed[:att_tok] = response['auth_token']
        session[:ad] = true
        
        format.html { redirect_to attendances_path, notice: 'Bienvenido' }
      else
        format.html { redirect_to login_admin_path, alert: 'Email or password incorrect' }
      end
    end
  end

  def sign_in_user
    r = RunaApi.user_connect(params[:email], params[:password])
    response = JSON.parse(r.body)

    respond_to do |format|
      if r.code == 200
        cookies.signed[:email] = params[:email]
        cookies.signed[:att_tok] = response['auth_token']
        session[:ad] = false
        format.html { redirect_to attendances_path, notice: 'Welcome' }
      else
        format.html { redirect_to login_user_path, alert: response['message'] }
      end
    end

  end

  def log_out
    session.delete(:ad)
    cookies.delete(:email)
    cookies.delete(:att_tok)
    redirect_to login_admin_path, notice: 'Bye!'
  end

end
