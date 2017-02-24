require 'test_helper'

class OptionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @other_user = users(:lenneth)
    @recorder = recorders(:hoge)
    @option = options(:hoge)
  end

  test "should redirect index when not logged in" do
    get recorder_options_path(@recorder)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as wrong user" do
    log_in_as(@other_user)
    get recorder_options_path(@recorder)
    assert_redirected_to root_url
  end


  test "should redirect edit when not logged in" do
    get edit_option_path(@recorder)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    assert_no_difference 'Option.count' do
      patch option_path(@recorder), params: { recorder: { title: "example",
                                             options_attributes: { "0" => { name: "hoge",
                                                                            _destroy: false } } } }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_option_path(@recorder)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Option.count' do
      patch option_path(@recorder), params: { recorder: { title: "example",
                                             options_attributes: { "0" => { name: "hoge",
                                                                            _destroy: false } } } }
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Option.count' do
      delete option_path(@option)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Option.count' do
      delete option_path(@option)
    end
    assert_redirected_to root_url
  end


end
