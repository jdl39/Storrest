require 'test_helper'

class ArbiterControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get trim" do
    get :trim
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get owned" do
    get :owned
    assert_response :success
  end

end
