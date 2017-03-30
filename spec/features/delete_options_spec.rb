require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "DeleteOptions", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  describe "選択肢を削除" do
    before(:each) {
      log_in_as user
      visit edit_recorder_path(recorder)
    }

    specify '選択肢の単発削除が反映される', js: true do
      expect {
        option = recorder.options.first
        option_id = option.id
        within "#option-#{option.id}" do
          find('.dropdown-toggle').click
          click_on "削除"
        end

        within ".modal-container", visible: false do
          wait_for_css '.modal-form'
          expect(page).to have_content option.name
          click_on 'はい'
        end

        #変更を待つ
        wait_for_no_css '.modal-form'
        #変更の確認
        check_alert_seccess
        expect(page).not_to have_css "#option-#{option_id}"
        expect(option).not_to eq recorder.options.first
      }.to change { Option.count }.by(-1)
    end

    describe "チェックボックス" do
      before(:each) {
        unchecked_all?
        buttons_disabled?
      }
      specify '選択肢の選択削除が反映される', js: true do
        expect {
          options = recorder.options
          options = [options.first, options.second, options.third]
          options.each do |option|
            within "#option-#{option.id}" do
              check "ids_"
            end
            buttons_enabled?
          end

          within ".options-buttons" do
            click_on '削除'
          end
          within ".modal-container", visible: false do
            wait_for_css '.modal-form'
            options.each do |option|
              expect(page).to have_content option.name
            end
            click_on 'はい'
          end

          #変更を待つ
          wait_for_no_css '.modal-form'
          check_alert_seccess
          #変更の確認
          options.each do |option|
            expect(page).not_to have_css "#option-#{option.id}"
          end
        }.to change { Option.count }.by(-3)
      end

      specify "全選択をクリックするとチェックボックスが全て選択され全選択解除が有効化される", js: true do
        within ".options-buttons" do
          click_button "全選択"
        end
        checked_all?
        buttons_enabled?
        within ".options-buttons" do
          click_button "全選択解除"
        end
        unchecked_all?
        buttons_disabled?
      end

      specify "全選択はチェックボックスが空ではなくても有効である", js: true do
        within "#option-#{recorder.options.first.id}" do
          check "ids_"
        end
        buttons_enabled?
        within ".options-buttons" do
          click_button "全選択"
        end
        checked_all?
      end

      specify "全選択解除はチェックボックスが全て選択されていなくても有効である", js: true do
        within "#option-#{recorder.options.first.id}" do
          check "ids_"
        end
        within "#option-#{recorder.options.last.id}" do
          check "ids_"
        end
        buttons_enabled?
        within ".options-buttons" do
          click_button "全選択解除"
        end
        unchecked_all?
      end
    end
  end

  def checked_all?
    #チェックボックスがチェックされていることの確認
    recorder.options.each do |option|
      within "#option-#{option.id}" do
        expect(page).to have_checked_field "ids_"
      end
    end
  end

  def unchecked_all?
    #チェックボックスがチェックされていないことの確認
    recorder.options.each do |option|
      within "#option-#{option.id}" do
        expect(page).to have_unchecked_field "ids_"
      end
    end
  end

  def buttons_disabled?
    #削除ボタンが無効化されていることを確認
    #選択解除ボタンが存在しないことを確認
    within ".options-buttons" do
      expect(page).to have_button "削除", disabled: true
      expect(page).not_to have_css ".uncheck_all"
    end
  end

  def buttons_enabled?
    #削除ボタンが有効化されていることを確認
    #選択解除ボタンが存在することを確認
    within ".options-buttons" do
      expect(page).to have_button "削除", disabled: false
      expect(page).to have_css ".uncheck_all"
    end
  end
end

