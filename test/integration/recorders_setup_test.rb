require 'test_helper'

class RecordersSetupTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hoge)
  end

  test "invalid setup information" do
    log_in_as(@user)
    get user_setup_path(@user)
    assert_select "form[action=?]", user_setup_path(@user)
    assert_no_difference 'Recorder.count' do
      assert_no_difference 'Option.count' do
        post user_setup_path(@user), params: { recorder: { title: "",
                                               options_attributes: { "0" => { name: "hoge",
                                                                          _destroy: false } } } }
      end
    end
    assert_template 'recorders/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid setup information with friendly forwarding" do
    get user_setup_path(@user)
    log_in_as(@user)
    assert_redirected_to user_setup_url(@user)
    follow_redirect!
    assert_select "form[action=?]", user_setup_path(@user)
    assert_difference 'Recorder.count', 1 do
      assert_difference 'Option.count', 1 do
        post user_setup_path(@user), params: { recorder: { title: "example",
                                               options_attributes: { "0" => { name: "hoge",
                                                                          _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
    assert_not flash.empty?
  end

  test "register multiple options" do
    log_in_as(@user)
    get user_setup_path(@user)
    assert_difference 'Recorder.count', 1 do
      assert_difference 'Option.count', 3 do
        post user_setup_path(@user), params: { recorder: { title: "example",
                                               options_attributes: { "0" => { name: "hoge",
                                                                          _destroy: false },
                                                                     "1" => { name: "piyo",
                                                                          _destroy: false },
                                                                     "2" => { name: "fuga",
                                                                          _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
    assert_not flash.empty?
  end
end
