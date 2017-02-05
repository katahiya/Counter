require 'test_helper'

class RecordersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @recorder = recorders(:hoge)
  end

  test "profile display" do
    get recorder_path(@recorder)
    assert_template 'recorders/show'
    assert_select 'title', full_title(@recorder.title)
    assert_select 'h1', text: @recorder.title
    @recorder.options.each do |option|
      assert_match option.data, response.body
    end
    @recorder.records.each do |record|
      assert_match record.data, response.body
    end
  end
end