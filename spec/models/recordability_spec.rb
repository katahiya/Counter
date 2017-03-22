require 'rails_helper'

RSpec.describe Recordability, type: :model do
  let(:user) {
    create(:user)
  }
  let(:recorder) {
    create(:recorder, user: user)
  }
  let(:option) {
    create(:option, recorder: recorder)
  }
  let(:recordability) {
    build(:recordability, recorder: recorder)
  }

  specify "should be valid" do
    expect(recordability).to be_valid
  end

  specify "recorder_id should be present" do
    recordability.recorder = nil
    expect(recordability).not_to be_valid
  end

  specify "保有するrecordは連動して削除されなけてばならない" do
    user_with_descendants = create(:user, :with_descendants)
    first_recorder = user_with_descendants.recorders.first
    first_recordability = first_recorder.recordabilities.first
    records_count = first_recordability.records.count
    expect(records_count).to be > 0
    expect { first_recordability.destroy }.to change { Record.count }.by(-records_count)
  end
end
