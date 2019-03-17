class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorized
    if cookies.signed[:att_tok].present?
      @api = RunaApi.new(cookies.signed[:att_tok])
    else
      redirect_to login_user_path, notice: "Please Sign In"
    end
  end
end
