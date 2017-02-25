require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  def setup
    @recorder = recorders(:hoge)
    @record = @recorder.records.build(option: @recorder.options.first)
  end

  test "should be valid" do
    assert @record.valid?
  end

  test "recorder_id should be present" do
    @record.recorder_id = "    "
    assert_not @record.valid?
  end

  test "option_id should be present" do
    @record.option_id = "    "
    assert_not @record.valid?
  end

  test "order should be most recent first" do
    assert_equal records(:most_recent), Record.first
  end
end
