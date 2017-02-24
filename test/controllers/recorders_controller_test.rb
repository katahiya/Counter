require 'test_helper'

class RecordersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hoge)
    @other_user = users(:lenneth)
    @recorder = recorders(:hoge)
  end

  test "should redirect setup when not logged in" do
    get user_setup_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Recorder.count' do
      post user_setup_path(@user), params: { recorder: { title: "example",
                                             options_attributes: { "0" => { name: "hoge",
                                                                            _destroy: false } } } }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect setup when logged in as wrong user" do
    log_in_as(@other_user)
    get user_setup_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect create when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Recorder.count' do
      post user_setup_path(@user), params: { recorder: { title: "example",
                                             options_attributes: { "0" => { name: "hoge",
                                                                            _destroy: false } } } }
    end
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get edit_recorder_path(@recorder)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect add_options when not logged in" do
    get recorder_add_options_path(@recorder)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch recorder_path(@recorder), params: { recorder: { title: "onion",
                                                          options_attributes: { "0" => { name: "fire",
                                                                                         _destroy: false } } } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_recorder_path(@recorder)
    assert_redirected_to root_url
  end

  test "should redirect add_options when logged in as wrong user" do
    log_in_as(@other_user)
    get recorder_add_options_path(@recorder)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch recorder_path(@recorder), params: { recorder: { title: "onion",
                                                          options_attributes: { "0" => { name: "fire",
                                                                                         _destroy: false } } } }
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Recorder.count' do
      delete recorder_path(@recorder)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Recorder.count' do
      delete recorder_path(@recorder)
    end
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get user_recorders_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as wrong user" do
    log_in_as(@other_user)
    get user_recorders_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect show when not logged in" do
    get recorder_path(@recorder)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when logged in as wrong user" do
    log_in_as(@other_user)
    get recorder_path(@recorder)
    assert_redirected_to root_url
  end

  test "should get new" do
    log_in_as(@user)
    get user_setup_path(@user)
    assert_response :success
  end

end
