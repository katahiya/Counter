require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  specify "user should be valid" do
    expect(user).to be_valid
  end

  specify "email は空であってはならない" do
    user.email = ""
    expect(user).not_to be_valid
    expect(user.errors[:email]).to be_present
  end

  specify "emailは255文字を超えてはならない" do
    user.email = "a" * 244 + "@example.com"
    expect(user).not_to be_valid
    user.email = "a" * 243 + "@example.com"
    expect(user).to be_valid
  end

  specify "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.orz first.last@foo.jp alice+bob@baz.cb]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  specify "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com US_E_Rfoo.COM A_USER@example.com@foo.bar.orz first.last@fo_o.jp alice@baz+bob.cb]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid
    end
  end

  specify "email addresses should be unique" do
    duplicated_user = user.dup
    duplicated_user.email = user.email.upcase
    user.save
    expect(duplicated_user).not_to be_valid
  end

  specify "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExamPlE.COm"
    user.email = mixed_case_email
    user.save
    expect(mixed_case_email.downcase).to eq user.reload.email
  end

  specify "order should be most recent last" do
    expect(User.all.to_sql).to eq User.unscoped.order(:created_at).to_sql
  end

  specify "password should be present" do
    user.password = user.password_confirmation = " " * 6
    expect(user).not_to be_valid
  end

  specify "password should have a minimum length" do
    user.password = user.password_confirmation = "a" * 5
    expect(user).not_to be_valid
  end

  specify "保有するrecorderは連動して削除されなけてばならない" do
    user_with_recorder = create(:user, :with_descendants)
    recorder_count = user_with_recorder.recorders.count
    expect(recorder_count).to be > 0
    expect { user_with_recorder.destroy }.to change { Recorder.count }.by(-recorder_count)
  end

end
