require 'rest-client'
class RunaApi

  def initialize(token)
    @attendance_path = Rails.application.secrets.runa_api_base + "attendances"
    @user_path = Rails.application.secrets.runa_api_base + "users"
    @token = token
  end

  # Login Requests
  def self.admin_connect(email, pass)
    RestClient.post Rails.application.secrets.runa_api_base + "auth/admin_login", {email: email, password: pass}.to_json, {content_type: :json, accept: :json}
  end

  def self.user_connect(email, pass)
    RestClient.post Rails.application.secrets.runa_api_base + "auth/user_login", {email: email, password: pass}.to_json, {content_type: :json, accept: :json}
  end


  # Attendance Requests
  def create_attendance(params)
    RestClient.post @attendance_path, params.to_json, {content_type: :json, accept: :json, Authorization: @token}
  end

  def update_attendance(id, params)
    RestClient.put @attendance_path + "/#{id}", params.to_json, {content_type: :json, accept: :json, Authorization: @token}
  end

  def get_attendances
    RestClient.get @attendance_path, {content_type: :json, accept: :json, Authorization: @token}
  end

  def get_attendance(id)
    RestClient.get @attendance_path + "/#{id}", {content_type: :json, accept: :json, Authorization: @token}
  end

  def filter_attendances(option)
    options = "?"
    options += "&usr=#{option[:user_id]}" unless option[:user_id].nil?
    options += "&a_date=#{option[:date]}" unless option[:date].nil?
    options += "&a_date_from=#{option[:inputDesde]}" unless option[:inputDesde].nil?
    options += "&a_date_to=#{option[:inputHasta]}" unless option[:inputHasta].nil?
    
    RestClient.get @attendance_path + options, {content_type: :json, accept: :json, Authorization: @token}
  end

  def destroy_attendance(id)
    RestClient.delete @attendance_path + "/#{id}", {content_type: :json, accept: :json, Authorization: @token}
  end

  # User Requests
  def create_user(params)
    RestClient.post @user_path, params.to_json, {content_type: :json, accept: :json, Authorization: @token}
  end

  def update_user(id, params)
    params.delete(:password) if params[:password].nil? || params[:password] == ""
    RestClient.put @user_path + "/#{id}", params.to_json, {content_type: :json, accept: :json, Authorization: @token}
  end

  def get_users
    RestClient.get @user_path, {content_type: :json, accept: :json, Authorization: @token}
  end

  def get_user(id)
    RestClient.get @user_path + "/#{id}", {content_type: :json, accept: :json, Authorization: @token}
  end

  def filter_users(option)
    options = "?"
    options += "&rl=#{option[:role]}" unless option[:role].nil?
    options += "&firstname=#{option[:firstname]}" unless option[:firstname].nil?
    options += "&lastname=#{option[:lastname]}" unless option[:lastname].nil?
    options += "&dni=#{option[:dni]}" unless option[:dni].nil?
    RestClient.get @user_path + options, {content_type: :json, accept: :json, Authorization: @token}
  end

  def destroy_user(id)
    RestClient.delete @user_path + "/#{id}", {content_type: :json, accept: :json, Authorization: @token}
  end

end