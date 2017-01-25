require 'test_helper'

class RecorderTest < ActiveSupport::TestCase
  def setup
    @recorder = Recorder.new(title: "Example")
  end

  test "should be valid" do
    assert @recorder.valid?
  end

  test "title should be present" do
    @recorder.title = "     "
    assert_not @recorder.valid?
  end

  test "title should not be too long" do
    @recorder.title = "a" * 256
    assert_not @recorder.valid?
  end

=begin
  test "title should be unique" do
    duplicate_recorder = @recorder.dup
    duplicate_recorder.title = @recorder.title.upcase
    @recorder.save
    assert_not duplicate_recorder.valid?
  end
=end
end
