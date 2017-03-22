require 'rails_helper'

RSpec.describe Recorder, type: :model do
  let(:user) {
    create(:user)
  }
  let(:recorder) {
    build(:recorder, user: user)
  }

  specify "should be valid" do
    expect(recorder).to be_valid
  end

  specify "title should be present" do
    recorder.title = "     "
    expect(recorder).not_to be_valid
  end

  specify "user_id should be present" do
    recorder.user = nil
    expect(recorder).not_to be_valid
  end

  specify "title should not be too long" do
    recorder.title = "a" * 256
    expect(recorder).not_to be_valid
  end

  specify "associated options should be destroyd" do
    recorder_with_options = create(:recorder, :with_descendants, user: user)
    options_count = recorder_with_options.options.count
    expect(options_count).to be > 0
    expect { recorder_with_options.destroy }.to change { Option.count }.by(-options_count)
  end

  specify "associated records should be destroyed" do
    recorder_with_options = create(:recorder, :with_descendants, user: user)
    recordabilities_count = recorder_with_options.recordabilities.count
    expect(recordabilities_count).to be > 0
    expect { recorder_with_options.destroy }.to change { Recordability.count }.by(-recordabilities_count)
  end

  specify "order should be most recent updated first" do
    expect(Recorder.all.to_sql).to eq Recorder.unscoped.order(updated_at: :desc).to_sql
  end

end
