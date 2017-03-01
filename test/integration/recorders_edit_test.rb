require 'test_helper'

class RecordersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @isolated_recorder = recorders(:isolated)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get user_recorders_path(@user)
    get edit_recorder_path(@recorder), xhr: true
    assert_template 'recorders/edit'
    assert_match "action=\\\"#{recorder_path(@recorder)}\\\"", response.body
    patch recorder_path(@recorder), params: { recorder: { title: "" } }, xhr: true
    assert_template 'shared/_error_messages'
    assert_match 'error_explanation', response.body
  end

  test "successful edit with friendly forwarding" do
    get edit_recorder_path(@recorder), xhr: true
    log_in_as(@user)
    assert_redirected_to user_recorders_url(@user)
    follow_redirect!
    assert_template 'recorders/index'
    get edit_recorder_path(@recorder), xhr: true
    assert_template 'recorders/edit'
    assert_match "action=\\\"#{recorder_path(@recorder)}\\\"", response.body
    title = "onion"
    patch recorder_path(@recorder), params: { recorder: { title: title } }, xhr: true
    assert_template 'recorders/update'
    @recorder.reload
    assert_equal title, @recorder.title
    assert_template 'recorders/_recorder'
    assert_match "#{@recorder.title}", response.body
  end
end
