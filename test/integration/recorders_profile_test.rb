require 'test_helper'

class RecordersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @isolated_recorder = recorders(:isolated)
    @option = @recorder.options.first
  end

  test "profile display with any records with friendly forwarding" do
    get recorder_path(@recorder)
    log_in_as(@user)
    assert_redirected_to recorder_url(@recorder)
    follow_redirect!
    assert_template 'recorders/show'
    assert_select 'title', full_title(@recorder.title)
    assert_select 'h1', text: @recorder.title
    assert_select 'h2', text: "no options", count: 0
    assert_select 'a[href=?]', recorder_add_options_path(@recorder), count: 0
    @recorder.options.each do |option|
      assert_select "form input[data-disable-with=?]", option.name
    end
    assert_select 'h2', text: "no records", count: 0
    assert_select 'h2', text: "Records"
    assert_select 'div.table-responsive'
    assert_select 'div.records'
    @recorder.records.each do |record|
      assert_select "table td.record-data", text: record.option.name
      assert_select 'a[href=?]', record_path(record), text: 'delete'
    end
  end

  test "profile nothing display" do
    log_in_as(@user)
    get recorder_path(@isolated_recorder)
    assert_template 'recorders/show'
    assert_select 'title', full_title(@isolated_recorder.title)
    assert_select 'h1', text: @isolated_recorder.title
    assert_select "section.record_form", count: 0
    assert_select 'h2', text: "no options"
    assert_select 'a[href=?]', recorder_add_options_path(@isolated_recorder)
    assert_select 'h2', text: "no records"
    assert_select 'h2', text: "Records", count: 0
    assert_select 'div.table-responsive', count: 0
    assert_select 'div.records', count: 0
  end

end
