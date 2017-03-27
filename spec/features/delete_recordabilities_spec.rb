require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "DeleteRecordabilities", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  describe "記録を編集" do
    before(:each) {
      log_in_as user
      visit recorder_path(recorder)
    }

    specify '記録の単発削除が反映される', js: true do
      expect {
        recordability = recorder.recordabilities.first
        first_record_id = recordability.records.first.id
        within "#record-#{first_record_id}" do
          find('.dropdown-toggle').click
          click_on "削除"
        end

        within ".modal-container", visible: false do
          wait_for_css '.modal-form'
          recordability.records.each do |record|
            expect(page).to have_content record.option.name
            expect(page).to have_content record.count
          end
          click_on 'はい'
        end

        #変更を待つ
        wait_for_no_css '.modal-form'
        #変更の確認
        expect(page).not_to have_css "#record-#{first_record_id}"
        expect(recordability).not_to eq recorder.recordabilities.first
      }.to change { Recordability.count }.by(-1)
    end

  end
end
