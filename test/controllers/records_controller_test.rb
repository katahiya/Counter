require 'test_helper'

class RecordsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @other_user = users(:lenneth)
    @option = options(:hoge)
    @record = records(:hoge)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Record.count' do
      post option_records_path(@option)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Record.count' do
      delete record_path(@record)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Record.count' do
      post option_records_path(@option)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Record.count' do
      delete record_path(@record)
    end
    assert_redirected_to root_url
  end
end
