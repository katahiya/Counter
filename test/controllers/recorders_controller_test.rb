require 'test_helper'

class RecordersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get setup_path
    assert_response :success
  end

end
