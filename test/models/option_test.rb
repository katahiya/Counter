require 'test_helper'

class OptionTest < ActiveSupport::TestCase

  def setup
    @recorder = recorders(:hoge)
    @option = @recorder.options.build(name: "test")
  end

  test "should be valid" do
    assert @option.valid?
  end

  test "name should be present" do
    @option.name = "    "
    assert_not @option.valid?
  end

  test "name should be at most 40 characters" do
    @option.name = "a" * 41
    assert_not @option.valid?
  end

  test "order should be most recent last" do
    assert_equal options(:most_recent), Option.last
  end
end
