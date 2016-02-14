require 'test_helper'

class DailyFoodPlannerControllerTest < ActionController::TestCase
  test "should get enter" do
    get :enter
    assert_response :success
  end

end
