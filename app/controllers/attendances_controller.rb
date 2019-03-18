class AttendancesController < ApplicationController
  before_action :authorized
  require 'rest-client'
  # GET /attendances
  # GET /attendances.json
  def index
    r = @api.get_attendances
    response = JSON.parse(r.body)
    if r.code == 200
      @attendances = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
    # @attendances = Attendance.all
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    r = @api.get_users
    response = JSON.parse(r.body)
    if r.code == 200
      @users = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
    
  end

  # GET /attendances/1/edit
  def edit
    r = @api.get_attendance(params[:id])
    response = JSON.parse(r.body)
    if r.code == 200
      @attendance = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
  end

  # POST /attendances
  # POST /attendances.json
  def create
    attendance_params[:checkin] = attendance_params[:checkin].to_time
    attendance_params[:checkout] = attendance_params[:checkout].to_time
    attendance_params[:attendance_date] = attendance_params[:attendance_date].to_date

    r = @api.create_attendance(attendance_params)
    respond_to do |format|
      if r.code == 201
        format.html { redirect_to attendances_url, notice: 'Attendance was successfully created.' }
      else
        response = JSON.parse(r.body)
        format.html { redirect_to attendances_url, alert: response['message']}
      end
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    attendance_params[:checkout] = DateTime.parse(attendance_params[:checkout]) if attendance_params[:checkout].present?
    attendance_params[:attendance_date] = attendance_params[:attendance_date].to_date if attendance_params[:attendance_date].present?

    r = @api.update_attendance(params[:id], attendance_params)
    respond_to do |format|
      if r.code == 204
        format.html { redirect_to attendances_url, notice: 'Attendance was successfully updated.' }
      else
        response = JSON.parse(r.body)
        format.html { redirect_to attendances_url, alert: response['message']}
      end
    end
    
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    r = @api.destroy_attendance(params[:id])
    respond_to do |format|
      if r.code == 204
        format.html { redirect_to attendances_url, notice: 'Attendance was successfully destroy.' }
      else
        response = JSON.parse(r.body)
        format.html { redirect_to attendances_url, alert: response['message']}
      end
    end
  end

  def filter
    options = {}
    options[:user_id] = params[:user_id] if params[:user_id].present?
    options[:date] = params[:date] if params[:date].present?
    options[:inputDesde] = params[:inputDesde] if params[:inputDesde].present?
    options[:inputHasta] = params[:inputHasta] if params[:inputHasta].present?
    r = @api.filter_attendances(options)
    if r.code == 200
      response = JSON.parse(r.body)
      @attendances = response
    else
      redirect_to login_sign_in_admin_path, alert: response['message']
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(:checkin, :checkout, :user_id, :attendance_date)
    end
end
