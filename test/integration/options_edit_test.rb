require 'test_helper'

class OptionEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @option = options(:hoge)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get recorder_options_path(@recorder)
    get edit_option_path(@option), xhr: true
    assert_template 'options/edit'
    assert_template 'options/_edit'
    assert_match "action=\\\"#{option_path(@option)}\\\"", response.body
    patch option_path(@option), params: { option: { name: "  " } }, xhr: true
    assert_template 'shared/_error_messages'
    assert_match 'error_explanation', response.body
  end

  test "successful edit with friendly forwarding" do
    get edit_option_path(@option)
    log_in_as(@user)
    assert_redirected_to recorder_options_path(@recorder)
    follow_redirect!
    assert_template 'options/index'
    get edit_option_path(@option), xhr: true
    assert_template 'options/edit'
    assert_template 'options/_edit'
    assert_match "action=\\\"#{option_path(@option)}\\\"", response.body
    name = "white grint"
    patch option_path(@option), params: { option: { name: name } }, xhr: true
    @option.reload
    assert_equal name, @option.name
    assert_template 'options/_option'
    assert_match "#{@option.id}", response.body
    assert_match "#{@option.name}", response.body
  end

end
