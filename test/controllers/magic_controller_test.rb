require 'test_helper'

class MagicControllerTest < ActionController::TestCase
  test "should get cards" do
    get :cards
    assert_response :success
  end

end
