require 'test_helper'

class RecordersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hoge)
    @other_user = users(:lenneth)
    @recorder = recorders(:hoge)
  end

  test "should redirect setup when not logged in" do
    get setup_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Recorder.count' do
      post setup_path, params: { recorder: { title: "example",
                                             options_attributes: { "0" => { name: "hoge",
                                                                            _destroy: false } } } }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_recorder_path(@recorder)
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
    get recorders_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as wrong user" do
    log_in_as(@other_user)
    get recorders_path
    assert_redirected_to root_url
  end

  test "should get new" do
    log_in_as(@user)
    get setup_path
    assert_response :success
  end

end
