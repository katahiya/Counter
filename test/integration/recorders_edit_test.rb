require 'test_helper'

class RecordersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @isolated_recorder = recorders(:isolated)
    @option = @recorder.options.first
  end

=begin
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_recorder_path(@recorder)
    assert_template 'recorders/edit'

    get recorder_edit_title_path(@recorder), xhr: true
    patch recorder_edit_title_path(@recorder), params: { recorder: { title: "" } }, xhr: true
    assert_template 'shared/_error_messages'
    assert_select 'div#error_explanation'

    get edit_option_path(@option), xhr: true
    patch edit_option_path(@option), params: { option: { name: "" } }, xhr: true
    assert_template 'shared/_error_messages'
    assert_select 'error_explanation'
  end
=end

  test "successful edit with friendly forwarding" do
    get edit_recorder_path(@recorder)
    log_in_as(@user)
    assert_redirected_to edit_recorder_url(@recorder)
    follow_redirect!
    assert_template 'recorders/edit'
    assert_select 'a[href=?]', recorder_edit_title_path(@recorder), count: 1, remote: true
    assert_select 'h3', @recorder.title, 1
    @recorder.options.each do |option|
      assert_select 'a[href=?]', edit_option_path(option), count: 1, remote: true
      assert_select 'a[href=?]', delete_option_path(option), count: 1, remote: true
      assert_select 'h3', option.name, 1
    end
    assert_select 'a[href=?]', recorder_path(@recorder), 1, mothod: :delete
    assert_select 'a[href=?]', recorder_path(@recorder), 1

    title = "onion"
    patch recorder_edit_title_path(@recorder), params: { recorder: { title: title } }, xhr: true
    get edit_recorder_path(@recorder)
    assert_select 'h3', @recorder.title, 0
    @recorder.reload
    assert_select 'h3', title, count: 1
    assert_equal title, @recorder.title

    name = "gomennne"
    patch option_path(@option), params: { option: { name: name } }, xhr: true
    get edit_recorder_path(@recorder)
    @option.reload
    assert_select 'h3', name, count: 1
    assert_equal name, @option.name

    assert_difference 'Option.count', -1 do
      delete option_path(@option), xhr: true
    end
    get edit_recorder_path(@recorder)

    assert_difference 'Recorder.count', -1 do
      delete recorder_path(@recorder)
    end
    assert_redirected_to user_recorders_url(@user)
  end

end
