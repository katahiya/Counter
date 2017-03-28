require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "RecordersSetup", type: :feature do
  let(:user ) { create(:user, :with_descendants) }

  specify 'friendly forwarding' do
    test_friendly_forwarding(user_setup_path(user), 'form#new_recorder')
  end

  describe "フォームの送信" do
    before(:each) {
      log_in_as user
      visit user_setup_path(user)
    }

    specify 'recorderのみを作成する', js: true do
      expect {
        new_title = 'new_title'
        fill_in "recorder_title", with: new_title
        click_button '作成'
        wait_for_no_css 'form#new_recorder'
        user.reload
        recorder = user.recorders.first
        expect(recorder.title).to eq new_title
      }.to change { Recorder.count }.by(1)
    end

    specify 'recorderとoptionを同時に作成する', js: true do
      expect {
        expect {
          new_title = 'new_title'
          new_option_name = 'new_option'
          fill_in "recorder_title", with: new_title
          3.times do |n|
            click_on 'フォームを追加'
            page.all(".option_field")[n].set new_option_name + n.to_s
          end
          #空のフォームを作成し影響を及ぼさないことを確認
          click_on 'フォームを追加'
          click_button '作成'
          wait_for_no_css 'form#new_recorder'
          user.reload
          recorder = user.recorders.first
          expect(recorder.title).to eq new_title
          recorder.options.each_with_index do |option, index|
            expect(option.name).to eq new_option_name + index.to_s
          end
        }.to change { Option.count }.by(3)
      }.to change { Recorder.count }.by(1)
    end

    specify 'バリデーション失敗時にエラーを出力する', js: true do
      expect {
        fill_in "recorder_title", with: ""
        click_button '作成'
        expect(page).to have_css "#error_explanation"
      }.not_to change { Recorder.count }
    end

  end
end
