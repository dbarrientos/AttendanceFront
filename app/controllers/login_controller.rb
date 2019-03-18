class LoginController < ApplicationController
  def admin
    session.delete(:ad)
    session.delete(:uid)
    cookies.delete(:email)
    cookies.delete(:att_tok)
  end

  def user
    session.delete(:ad)
    session.delete(:uid)
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
        session[:uid] = response['uid']
        format.html { redirect_to attendances_path, notice: 'Bienvenido' }
      else
        format.html { redirect_to login_admin_path, alert: 'Email or password incorrect' }
      end
    end
  rescue RestClient::Unauthorized
    redirect_to login_admin_path, alert: 'Email or password incorrect'
  end

  def sign_in_user
    r = RunaApi.user_connect(params[:email], params[:password])
    response = JSON.parse(r.body)

    respond_to do |format|
      if r.code == 200
        cookies.signed[:email] = params[:email]
        cookies.signed[:att_tok] = response['auth_token']
        session[:ad] = false
        session[:uid] = response['uid']
        format.html { redirect_to attendances_path, notice: 'Welcome' }
      else
        format.html { redirect_to login_user_path, alert: response['message'] }
      end
    end
  rescue RestClient::Unauthorized
    redirect_to login_user_path, alert: 'Email or password incorrect'
  end

  def log_out
    session.delete(:ad)
    cookies.delete(:email)
    cookies.delete(:att_tok)
    redirect_to login_admin_path, notice: 'Bye!'
  end

end
