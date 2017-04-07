require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "DuplicateRecordabilities", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  describe "記録を複製する" do
    before(:each) {
      log_in_as user
      visit recorder_path(recorder)
    }

    specify '記録の複製が反映される', js: true do
      expect {
        first_recordability = recorder.recordabilities.first
        last_recordability = recorder.recordabilities.last
        record_id = last_recordability.records.first.id
        within "#record-#{record_id}" do
          find('.dropdown-toggle').click
          click_on "複製"
        end

        #変更を待つ
        check_alert_seccess
        #変更の確認
        recorder.reload
        new_recordability = recorder.recordabilities.first
        expect(new_recordability).not_to eq first_recordability
        expect(new_recordability.records.count).to eq last_recordability.records.count
        new_recordability.records.zip(last_recordability.records).each do |new, original|
          expect(new.option).to eq original.option
          expect(new.count).to eq original.count
        end
      }.to change { Recordability.count }.by(1)
    end
  end
end
