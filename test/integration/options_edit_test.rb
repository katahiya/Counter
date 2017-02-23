require 'test_helper'

class OptionEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @option = options(:hoge)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_option_path(@option)
    assert_template 'options/edit'
    assert_select "form[action=?]", option_path(@option)
    patch option_path(@option), params: { option: { name: "  " } }
    assert_template 'options/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_option_path(@option)
    log_in_as(@user)
    assert_redirected_to edit_option_url(@option)
    follow_redirect!
    assert_template 'options/edit'
    assert_select "form[action=?]", option_path(@option)
    name = "white grint"
    patch option_path(@option), params: { option: { name: name } }
    @option.reload
    assert_not flash.empty?
    assert_redirected_to recorder_options_url(@recorder)
    assert_equal name, @option.name
  end

end
