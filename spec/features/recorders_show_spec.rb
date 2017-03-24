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
        expect(page).to have_link nil, href: recorder_add_options_path(recorder)
        expect(page).to have_link nil, href: new_recorder_recordability_path(recorder)
      end
    end

    specify '記録の一覧を持つ' do
      expect(page).to have_link nil, href: graph_path(recorder)
      expect(page).to have_link nil, href: edit_recorder_path(recorder)
      recorder.recordabilities.each do |recordability|
        expect(page).to have_link nil, href: edit_recordability_path(recordability)
        expect(page).to have_link nil, href: delete_recordability_path(recordability)
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

  describe "ボタン及びリンク" do
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
  end
end
