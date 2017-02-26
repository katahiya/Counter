require 'test_helper'

class OptionsIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @option = options(:hoge)
  end

  test "index including options action links with friendly forwarding" do
    get recorder_options_path(@recorder)
    log_in_as(@user)
    assert_redirected_to recorder_options_url(@recorder)
    follow_redirect!
    assert_template 'options/index'
    assert_select 'a[href=?]', recorder_add_options_path(@recorder), count: 1, text: 'add options'
    @recorder.options.each do |option|
      assert_select 'td', text: option.name
      assert_select 'td a[href=?]', edit_option_path(option), text: 'edit'
      assert_select 'td a[href=?]', option_path(option), text: 'delete'
    end
    assert_select 'a[href=?]', recorder_path(@recorder), count: 1
    assert_difference 'Option.count', -1 do
      delete option_path(@option)
    end
  end
end
