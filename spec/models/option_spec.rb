require 'rails_helper'

RSpec.describe Option, type: :model do

  let(:user) {
    create(:user)
  }
  let(:recorder) {
    build(:recorder, user: user)
  }
  let(:option) {
    build(:option, recorder: recorder)
  }

  specify "should be valid" do
    expect(option).to be_valid
  end

  specify "name should be present" do
    option.name = "    "
    expect(option).not_to be_valid
  end

  specify "name should be at most 40 characters" do
    option.name = "a" * 41
    expect(option).not_to be_valid
  end

  specify "associated records should be destroyed" do
    user_with_descendants = create(:user, :with_descendants)
    option_with_records = user_with_descendants.recorders.first.options.first
    records_count = option_with_records.records.count
    expect(records_count).to be > 0
    expect { option_with_records.destroy }.to change { Record.count }.by(-records_count)
  end

  specify "order should be most recent last" do
    expect(Option.all.to_sql).to eq Option.unscoped.order(:created_at).to_sql
  end

  specify "nameはrecorder内でユニークである" do
    recorder.save
    option.save
    expect{ recorder.options.create(name: option.name) }.not_to change{ Option.count }
    other_recorder = create(:recorder, user: user)
    other_recorder.options.each do |o|
      expect(o.name).not_to eq option.name
    end
    expect{
      other_recorder.options.create(name: option.name)
    }.to change{ Option.count }.by(1)
  end
end
