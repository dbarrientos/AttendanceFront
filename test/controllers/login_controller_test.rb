require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get admin" do
    get login_admin_url
    assert_response :success
  end

  test "should get user" do
    get login_user_url
    assert_response :success
  end

end
