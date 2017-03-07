require 'test_helper'

class RecordersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
  end

  test "index including pagination and recorders links with friendly forwarding" do
    get user_recorders_path(@user)
    log_in_as(@user)
    assert_redirected_to user_recorders_url(@user)
    follow_redirect!
    assert_template 'recorders/index'
    assert_select 'div.pagination', 2
    assert_select 'a[href=?]', user_setup_path(@user), count: 1, text: 'create new'
    first_page_of_recorders = @user.recorders.paginate(page: 1)
    first_page_of_recorders.each do |recorder|
      assert_select 'a[href=?]', recorder_path(recorder), title: recorder.title
      assert_select 'a[href=?]', edit_recorder_path(recorder), text: 'edit title'
      assert_select 'a[href=?]', recorder_options_path(recorder), text: 'edit options'
      assert_select 'a[href=?]', delete_recorder_path(recorder), text: 'delete'
    end
  end

  test "recorder delete with friendly forwarding" do
    get delete_recorder_path(@recorder), xhr: true
    log_in_as(@user)
    assert_redirected_to user_recorders_url(@user)
    follow_redirect!
    assert_template 'recorders/index'
    get delete_recorder_path(@recorder), xhr: true
    assert_template 'recorders/delete'
    assert_match "href=\\\"#{recorder_path(@recorder)}\\\"", response.body
    assert_difference 'Recorder.count', -1 do
      delete recorder_path(@recorder), xhr: true
    end
    assert_template 'recorders/destroy'
    assert_template 'recorders/_recorders'
    assert_no_match "#{@recorder.title}", response.body
  end
end
