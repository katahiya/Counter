require 'test_helper'

class RecorderTest < ActiveSupport::TestCase
  def setup
    @user = users(:hoge)
    @recorder = @user.recorders.build(title: "Example")
  end

  test "should be valid" do
    assert @recorder.valid?
  end

  test "title should be present" do
    @recorder.title = "     "
    assert_not @recorder.valid?
  end

  test "user_id should be present" do
    @recorder.user_id = nil
    assert_not @recorder.valid?
  end

  test "title should not be too long" do
    @recorder.title = "a" * 256
    assert_not @recorder.valid?
  end

  test "associated options should be destroyd" do
    @recorder.save
    @recorder.options.create!(name: "onion")
    assert_difference 'Option.count', -1 do
      @recorder.destroy
    end
  end

  test "associated records should be destroyed" do
    @recorder.save
    @recorder.options.create!(name: "onion")
    @recorder.records.create!(option: @recorder.options.first)
    assert_difference 'Record.count', -1 do
      @recorder.destroy
    end
  end

  test "associated records created by option should be destroyed" do
    @recorder.save
    option = @recorder.options.build(name: "onion")
    option.save
    option.records.create!(recorder: @recorder)
    assert_difference 'Record.count', -1 do
      @recorder.destroy
    end
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
