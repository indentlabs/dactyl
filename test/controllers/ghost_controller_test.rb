require 'test_helper'

class GhostControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in create(:user)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get editor" do
    get :editor
    assert_response :success
  end

  test "should get browser" do
    get :browser
    assert_response :success
  end

end
