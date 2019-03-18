class UsersController < ApplicationController
  before_action :authorized
  require 'rest-client'
  # GET /users
  # GET /users.json
  def index
    r = @api.get_users
    response = JSON.parse(r.body)
    if r.code == 200
      @users = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    r = @api.get_user(params[:id])
    response = JSON.parse(r.body)
    if r.code == 200
      @user = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
    r = @api.get_user(params[:id])
    response = JSON.parse(r.body)
    if r.code == 200
      @user = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
  end

  # POST /users
  # POST /users.json
  def create
    r = @api.create_user(user_params)
    respond_to do |format|
      if r.code == 201
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
      else
        response = JSON.parse(r.body)
        format.html { redirect_to users_url, alert: response['message']}
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    user_params.delete[:password] if user_params[:password].nil?
    r = @api.update_user(params[:id], user_params)
    respond_to do |format|
      if r.code == 204
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
      else
        response = JSON.parse(r.body)
        format.html { redirect_to users_url, alert: response['message']}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    r = @api.destroy_user(params[:id])
    respond_to do |format|
      if r.code == 204
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
      else
        response = JSON.parse(r.body)
        format.html { redirect_to users_url, alert: response['message']}
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :dni, :address, :phone, :role)
  end
end
