require 'test_helper'

class RecordersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @isolated_recorder = recorders(:isolated)
  end

  test "profile display with any records with friendly forwarding" do
    get recorder_path(@recorder)
    log_in_as(@user)
    assert_redirected_to recorder_url(@recorder)
    follow_redirect!
    assert_template 'recorders/show'
    assert_select 'title', full_title(@recorder.title)
    assert_select 'h1', text: @recorder.title
    @recorder.options.each do |option|
      assert_select "form input[data-disable-with=?]", option.name
    end
    assert_select 'h2', text: "no records", count: 0
    assert_select 'h2', text: "Records"
    assert_select 'div.table-responsive'
    assert_select 'div.records'
    @recorder.records.each do |record|
      assert_select "table td.data", text: record.data
      assert_select 'a[href=?]', record_path(record), text: 'delete'
    end
  end

  test "profile display with no records" do
    log_in_as(@user)
    get recorder_path(@isolated_recorder)
    assert_template 'recorders/show'
    assert_select 'title', full_title(@isolated_recorder.title)
    assert_select 'h1', text: @isolated_recorder.title
    @isolated_recorder.options.each do |option|
      assert_select "form input[data-disable-with=?]", option.name
    end
    assert_select 'h2', text: "no records"
    assert_select 'h2', text: "Records", count: 0
    assert_select 'div.table-responsive', count: 0
    assert_select 'div.records', count: 0
  end

end
