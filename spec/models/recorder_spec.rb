require 'rails_helper'

RSpec.describe Recorder, type: :model do
  let(:recorder) { build(:recorder) }

  specify "should be valid" do
    expect(recorder).to be_valid
  end

  specify "title should be present" do
    recorder.title = "     "
    expect(recorder).not_to be_valid
  end

  specify "user_id should be present" do
    recorder.user_id = nil
    expect(recorder).not_to be_valid
  end

  specify "title should not be too long" do
    recorder.title = "a" * 256
    expect(recorder).not_to be_valid
  end

  specify "associated options should be destroyd" do
    @recorder.save
    @recorder.options.create!(name: "onion")
    assert_difference 'Option.count', -1 do
      @recorder.destroy
    end
  end

  specify "associated records should be destroyed" do
    @recorder.save
    @recorder.options.create!(name: "onion")
    @recorder.records.create!(option: @recorder.options.first)
    assert_difference 'Record.count', -1 do
      @recorder.destroy
    end
  end

  specify "associated records created by option should be destroyed" do
    @recorder.save
    option = @recorder.options.build(name: "onion")
    option.save
    option.records.create!(recorder: @recorder)
    assert_difference 'Record.count', -1 do
      @recorder.destroy
    end
  end

  specify "order should be most recent updated first" do
    assert_equal recorders(:latest_updated), Recorder.first
  end

end
