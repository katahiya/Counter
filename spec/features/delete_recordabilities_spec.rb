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

    describe "チェックボックス" do
      before(:each) {
        #チェックボックスがチェックされていないことの確認
        recorder.recordabilities.each do |r|
          within "#record-#{r.records.first.id}" do
            expect(page).to have_unchecked_field "ids_"
          end
        end
        #削除ボタンが無効化されていることを確認
        #選択解除ボタンが存在しないことを確認
        within ".records-buttons" do
          expect(page).to have_button "削除", disabled: true
          expect(page).not_to have_css ".uncheck_all"
        end
      }
      specify '記録の選択削除が反映される', js: true do
        expect {
          recordabilities = recorder.recordabilities
          first_id = recordabilities.first.records.first.id
          second_id = recordabilities.second.records.first.id
          third_id = recordabilities.third.records.first.id
          [first_id, second_id, third_id].each do |id|
            within "#record-#{id}" do
              check "ids_"
            end
            #削除ボタンが有効化されていることを確認
            #選択解除ボタンが存在することを確認
            within ".records-buttons" do
              expect(page).to have_button "削除", disabled: false
              expect(page).to have_css ".uncheck_all"
            end
          end

          within ".records-buttons" do
            click_on '削除'
          end
          within ".modal-container", visible: false do
            wait_for_css '.modal-form'
            [recordabilities.first, recordabilities.second, recordabilities.third].each do |recordability|
              recordability.records.each do |record|
                expect(page).to have_content record.option.name
                expect(page).to have_content record.count
              end
            end
            click_on 'はい'
          end

          #変更を待つ
          wait_for_no_css '.modal-form'
          #変更の確認
          [first_id, second_id, third_id].each do |id|
            expect(page).not_to have_css "#record-#{id}"
          end
        }.to change { Recordability.count }.by(-3)
      end

      specify "全選択をクリックするとチェックボックスが全て選択され全選択解除が有効化される", js: true do
        within ".records-buttons" do
          click_button "全選択"
        end
        #全てのチェックボックスがチェックされていることの確認
        recorder.recordabilities.each do |r|
          within "#record-#{r.records.first.id}" do
            expect(page).to have_checked_field "ids_"
          end
        end
        #削除ボタンが有効化されていることを確認
        #選択解除ボタンが存在することを確認
        within ".records-buttons" do
          expect(page).to have_button "削除", disabled: false
          expect(page).to have_css ".uncheck_all"
          click_button "全選択解除"
        end
        #チェックボックスがチェックされていないことの確認
        recorder.recordabilities.each do |r|
          within "#record-#{r.records.first.id}" do
            expect(page).to have_unchecked_field "ids_"
          end
        end
        #削除ボタンが無効化されていることを確認
        #選択解除ボタンが存在しないことを確認
        within ".records-buttons" do
          expect(page).to have_button "削除", disabled: true
          expect(page).not_to have_css ".uncheck_all"
        end
      end

      specify "全選択はチェックボックスが空ではなくても有効である", js: true do
        within "#record-#{recorder.recordabilities.first.records.first.id}" do
          check "ids_"
        end
        #削除ボタンが有効化されていることを確認
        #選択解除ボタンが存在することを確認
        within ".records-buttons" do
          expect(page).to have_button "削除", disabled: false
          expect(page).to have_css ".uncheck_all"
          click_button "全選択解除"
        end
        within ".records-buttons" do
          click_button "全選択"
        end
        #全てのチェックボックスがチェックされていることの確認
        recorder.recordabilities.each do |r|
          within "#record-#{r.records.first.id}" do
            expect(page).to have_checked_field "ids_"
          end
        end
      end

      specify "全選択解除はチェックボックスが全て選択されていなくても有効である", js: true do
        within "#record-#{recorder.recordabilities.first.records.first.id}" do
          check "ids_"
        end
        within "#record-#{recorder.recordabilities.last.records.first.id}" do
          check "ids_"
        end
        #削除ボタンが有効化されていることを確認
        #選択解除ボタンが存在することを確認
        within ".records-buttons" do
          expect(page).to have_button "削除", disabled: false
          expect(page).to have_css ".uncheck_all"
          click_button "全選択解除"
        end
        #削除ボタンが無効化されていることを確認
        #選択解除ボタンが存在しないことを確認
        within ".records-buttons" do
          expect(page).to have_button "削除", disabled: true
          expect(page).not_to have_css ".uncheck_all"
        end
      end
    end
  end
end
