require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  def setup
    @recorder = recorders(:hoge)
    @record = @recorder.records.build(data: "test")
  end

  test "should be valid" do
    assert @record.valid?
  end

  test "data should be present" do
    @record.data = "    "
    assert_not @record.valid?
  end

  test "data should be at most 40 characters" do
    @record.data = "a" * 41
    assert_not @record.valid?
  end

  test "order should be most recent first" do
    assert_equal records(:most_recent), Record.first
  end
end
