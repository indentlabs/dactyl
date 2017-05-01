require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in create(:user)
  end
  
  test "should get update_resource" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in create(:user) 
    
    get :update_resource
    assert_response :success
  end

end
