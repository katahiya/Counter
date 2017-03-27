require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "EditRecordabilities", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  describe "記録を編集" do
    before(:each) {
      log_in_as user
      visit recorder_path(recorder)
    }

    specify '記録の変更が反映される', js: true do
      recordability = recorder.recordabilities.first
      first_record = recordability.records.first
      #変更前にoptions.firstの数量は0ではないことの確認
      within "#record-#{first_record.id}" do
        expect(page).to have_content first_record.option.name
        expect(page).to have_content first_record.count
        expect(first_record.option).to eq recorder.options.first
        expect(first_record.count).not_to eq 0
        find('.dropdown-toggle').click
        click_on "編集"
      end

      within ".modal-container", visible: false do
        wait_for_css 'form.edit_recordability'
        #options.firstの数量を0に変更
        recorder.options.each_with_index do |option, index|
          expect(page).to have_content option.name
          select index, from: option.name
        end
        click_button '変更'
      end

      #記録の変更を待つ
      wait_for_no_css 'form.edit_recordability'
      recordability.reload
      i = 1
      zipped = recordability.records.zip(recorder.options.select { |option|
        option != recorder.options.first
      })
      zipped.each do |record, option|
        expect(record.count).to eq i
        expect(record.option).to eq option
        within "#record-#{record.id}" do
          expect(page).to have_content record.option.name
          expect(page).to have_content record.count
        end
        i += 1
      end
    end

    specify '複数の記録を変更する際に全ての数量が0ならエラー', js: true do
      recordability = recorder.recordabilities.first
      first_record = recordability.records.first
      within "#record-#{first_record.id}" do
        find('.dropdown-toggle').click
        click_on "編集"
      end

      within ".modal-container", visible: false do
        wait_for_css 'form.edit_recordability'
        recorder.options.each do |option|
          select 0, from: option.name
        end
        click_button '変更'
      end

      wait_for_css "#error_explanation"
      within "#error_explanation" do
        wait_for_content '数量が全て0です'
      end
      expect(recordability).to eq recorder.recordabilities.first
    end

   end

end
