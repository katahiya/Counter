require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "AddRecordabilities", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  describe "記録の追加" do
    before(:each) {
      log_in_as user
      visit recorder_path(recorder)
    }

    specify '選択肢名をクリックすると記録が追加される' do
      option = recorder.options.first
      click_on option.name
      recordability = recorder.recordabilities.first
      record = recordability.records.first
      expect(record.count).to eq 1
      expect(record.option.name).to eq option.name
      check_alert_seccess
      within "#record-#{record.id}" do
        expect(page).to have_content record.option.name
        expect(page).to have_content record.count
      end
    end

    describe "モーダルウィンドウ" do
      before(:each) {
        expect(page).not_to have_css 'form.edit_recorder'
        within ".option-bar" do
          find('.dropdown-toggle').click
          click_on "まとめて記録"
        end
      }

      specify 'モーダルウィンドウで複数の記録を追加する', js: true do
        within ".modal-container", visible: false do
          wait_for_css '.batch_registration-form'
          recorder.options.each.with_index(1) do |option, index|
            select index, from: option.name
          end
          click_button '追加'
        end
        wait_for_no_css '.batch_registration-form'
        check_alert_seccess
        recordability = recorder.recordabilities.first
        i = 1
        recordability.records.zip(recorder.options).each do |record, option|
          within "#record-#{record.id}" do
            expect(page).to have_content record.option.name
            expect(page).to have_content record.count
            expect(record.option).to eq option
            expect(record.count).to eq i
          end
          i += 1
        end
      end

      specify '複数の記録を追加する際に数量が0なら記録されない', js: true do
        within ".modal-container", visible: false do
          wait_for_css '.batch_registration-form'
          recorder.options.each_with_index do |option, index|
            index == 0 ? count = 1 : count = 0
            select count, from: option.name
          end
          click_button '追加'
        end
        wait_for_no_css '.batch_registration-form'
        recordability = recorder.recordabilities.first
        record= recordability.records.first
        expect(record.option).to eq recorder.options.first
        expect(record.count).to eq 1
        expect(recordability.records.count).to eq 1
        within "#record-#{record.id}" do
          expect(page).to have_content record.option.name
          expect(page).to have_content record.count
        end
      end

      specify '複数の記録を追加する際に全ての数量が0ならエラー', js: true do
        expect {
          before_first_recordability = recorder.recordabilities.first
          within ".modal-container", visible: false do
            wait_for_css '.batch_registration-form'
            recorder.options.each_with_index do |option, index|
              select 0, from: option.name
            end
            click_button '追加'
          end
          wait_for_css "#error_explanation"
          within "#error_explanation" do
            wait_for_content '数量が全て0です'
          end
          expect(before_first_recordability).to eq recorder.recordabilities.first
        }.not_to change { Recordability.count }
      end
    end
  end
end
