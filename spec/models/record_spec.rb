require 'rails_helper'

RSpec.describe Record, type: :model do
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
    create(:recordability, recorder: recorder)
  }
  let(:record) {
    build(:record, count: 1, recordability: recordability, option: option)
  }

  specify "should be valid" do
    expect(record).to be_valid
  end

  specify "recordability_id should be present" do
    record.recordability = nil
    expect(record).not_to be_valid
  end

  specify "option_id should be present" do
    record.option = nil
    expect(record).not_to be_valid
  end

 specify "recordはorderの作成順でなければならない" do
    user_with_descendants = create(:user, :with_descendants)
    first_recorder = user_with_descendants.recorders.first
    first_recordability = first_recorder.recordabilities.first
    target_record = first_recordability.records.first
    first_recordability.records.each do |record|
      expect(target_record.option.created_at).to be <= record.option.created_at
      target_record = record
    end
  end
end
