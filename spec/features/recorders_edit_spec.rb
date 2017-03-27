require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "RecorderEdits", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  specify 'friendly forwarding' do
    test_friendly_forwarding(edit_recorder_path(recorder), 'div.recorder-items')
  end

  describe "ページレイアウト" do
    before(:each) {
      log_in_as user
      visit edit_recorder_path(recorder)
    }

    specify 'カウンター名と名前編集用のリンクを持つ' do
      expect(page).to have_content recorder.title
      expect(page).to have_link nil, href: recorder_edit_title_path(recorder)
    end

    specify '選択肢一覧と追加,編集,削除のリンクを持つ' do
      expect(page).to have_link nil, href: recorder_add_options_path(recorder)
      recorder.options.each do |option|
        expect(page).to have_content option.name
        expect(page).to have_link nil, href: edit_option_path(option), visible: false
        expect(page).to have_link nil, href: delete_option_path(option), visible: false
      end
    end

    specify 'カウンター削除のリンクを持つ' do
      expect(page).to have_link nil, href: delete_recorder_path(recorder)
    end

    specify 'recorder showへのリンクを持つ' do
      expect(page).to have_link nil, href: recorder_path(recorder)
    end
  end

  describe "カウンター名の編集" do
    before(:each) {
      log_in_as user
      visit edit_recorder_path(recorder)
      find('.edit_title_path').click
    }

    specify 'モーダルウィンドウを通してカウンター名を編集する', js: true do
      new_title = 'zero the movie'
      expect(recorder.title).not_to eq new_title
      within ".modal-container", visible: false do
        wait_for_css '.modal-form'
        fill_in '新しい名前', with: new_title
        click_button '変更'
      end
      wait_for_no_css '.modal-form'
      recorder.reload
      expect(recorder.title).to eq new_title
      expect(page).to have_content recorder.title
    end

    specify 'バリデーション失敗時にエラーを出力する', js: true do
      new_title = 'A' * 256
      expect(recorder.title).not_to eq new_title
      within ".modal-container", visible: false do
        wait_for_css '.modal-form'
        fill_in '新しい名前', with: new_title
        click_button '変更'
      end
      wait_for_css "#error_explanation"
      recorder.reload
      expect(recorder.title).not_to eq new_title
    end
  end

  describe "選択肢の追加" do
    before(:each) {
      log_in_as user
      visit edit_recorder_path(recorder)
      find('.add_options_path').click
    }
    specify 'モーダルウィンドウで選択肢を追加する', js: true do
      expect {
        new_option_name = 'new_option'
        within ".modal-container", visible: false do
          wait_for_css '.modal-form'
          3.times do |n|
            click_on 'フォームを追加'
            page.all(".option_field")[n].set new_option_name + n.to_s
          end
          #空のフォームを作成し影響を及ぼさないことを確認
          click_on 'フォームを追加'
          click_button '追加'
        end
        wait_for_no_css '.modal-form'
        within ".options_table" do
          3.times do |n|
            expect(page).to have_content new_option_name + n.to_s
          end
        end
      }.to change { Option.count }.by(3)
    end

    specify 'バリデーション失敗時にエラーを出力する', js: true do
      expect {
        within ".modal-container", visible: false do
          wait_for_css '.modal-form'
          page.first(".option_field").set "a" * 41
          click_button '追加'
        end
        wait_for_css "#error_explanation"
      }.not_to change { Option.count }
    end

    specify 'フォームが全て空の場合にエラーを出力する', js: true do
      expect {
        within ".modal-container", visible: false do
          wait_for_css '.modal-form'
          3.times do |n|
            click_on 'フォームを追加'
          end
          click_button '追加'
        end
        #wait_for_css "#error_explanation"
        expect(page).to have_css "#error_explanation"
      }.not_to change { Option.count }
    end

  end

end
