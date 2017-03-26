require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "RecordersShow", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }

  specify 'friendly forwarding' do
    test_friendly_forwarding(recorder_path(recorder), 'div.records-table')
  end

  describe "ページレイアウト" do
    before(:each) {
      log_in_as user
      visit recorder_path(recorder)
    }
    specify '記録追加のリンクを持つ' do
      recorder.options.each do |option|
        within '.options-col' do
          expect(page).to have_link option.name, href: single_register_path(option)
        end
      end
      within '.options-col' do
        expect(page).to have_link nil, href: recorder_add_options_path(recorder), visible: false
        expect(page).to have_link nil, href: new_recorder_recordability_path(recorder), visible: false
      end
    end

    specify '記録の一覧を持つ' do
      expect(page).to have_link nil, href: graph_path(recorder)
      expect(page).to have_link nil, href: edit_recorder_path(recorder)
      recorder.recordabilities.each do |recordability|
        expect(page).to have_link nil, href: edit_recordability_path(recordability), visible: false
        expect(page).to have_link nil, href: delete_recordability_path(recordability), visible: false
        recordability.records.each do |record|
          within "#record-#{record.id}" do
            expect(page).to have_content record.option.name
            expect(page).to have_content record.count
          end
        end
      end
    end

    specify '記録がない場合はそのことを表示する' do
      empty_recorder = create(:recorder, user: user)
      visit recorder_path(empty_recorder)
      expect(page).to have_content "記録はまだありません"
    end
  end

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
          within "#error_explanation", visible: false do
            wait_for_content '数量が全て0です'
          end
          expect(before_first_recordability).to eq recorder.recordabilities.first
        }.not_to change { Recordability.count }
      end
    end
  end

  describe "ボタン及びリンク" do
    before(:each) {
      log_in_as user
      visit recorder_path(recorder)
    }

    specify 'モーダルウィンドウで記録を編集', js: true do
      recordability = recorder.recordabilities.first
      #変更前にoptions.firstの数量は0ではないことの確認
      first_record = recordability.records.first
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
      recordability.records.each_with_index do |record, index|
        expect(record.count).to eq index
        if index == 0
          expect(page).not_to have_css "#record-#{record.id}"
          next
        end
        within "#record-#{record.id}" do
          expect(page).to have_content record.option.name
          expect(page).to have_content record.count
        end
      end
    end

    specify 'モーダルウィンドウでgraph表示', js: true do
      expect(page).not_to have_css '.graph'
      expect(page).to have_css '.graph_path'
      find('.graph_path').click
      within ".modal-container" do
        wait_for_css '.graph'
      end
    end

    specify 'モーダルウィンドウで選択肢を追加する', js: true do
      expect(page).not_to have_css 'form.edit_recorder'
      within ".option-bar" do
        find('.dropdown-toggle').click
        click_on "選択肢を追加"
      end
      new_option_name = 'new_option'
      within ".modal-container", visible: false do
        wait_for_css 'form.edit_recorder'
        fill_in '名前', with: new_option_name
        click_button '追加'
      end
      within ".option-bar" do
        wait_for_content new_option_name
      end
    end

  end
end
