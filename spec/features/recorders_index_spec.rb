require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "RecordersIndexes", type: :feature do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorders) { user.recorders.paginate(page: 1) }

  specify 'friendly forwarding' do
    test_friendly_forwarding(user_recorders_path(user), 'div#recorders_index')
  end

  describe "ページレイアウト " do
    specify 'recorderの数が多い場合はページが表示される' do
      p_user = create(:user, :with_paginate)
      log_in_as p_user
      visit user_recorders_path(p_user)
      expect(page).to have_link nil, href: user_setup_path(p_user)
      i = 1
      current_page_recorders = p_user.recorders.paginate(page: i)
      while current_page_recorders.empty? do
        within '#first_pagination' do
          click_on i
        end
        current_page_recorders.each do |recorder|
          expect(page).to have_link nil, href: recorder_path(recorder)
          expect(page).to have_link nil, href: edit_recorder_path(recorder)
          expect(page).to have_link nil, href: delete_recorder_path(recorder)
        end
        i += 1
        current_page_recorders = p_user.recorders.paginate(page: i)
      end
    end

    specify 'recorderの数が少ない場合はページーネーションがない' do
      log_in_as user
      visit user_recorders_path(user)
      expect(page).not_to have_css('div.pagination')
    end
  end

  describe 'モーダルウィンドウ' do
    specify 'recorderの削除', js: true do
      log_in_as user
      visit user_recorders_path(user)
      recorder = recorders.first
      expect(page).to have_content recorder.title
      within "#recorder-#{recorder.id}" do
        find('.dropdown-toggle').click
        click_on "削除"
      end
      wait_for_css '.modal-form'
      within ".modal-container" do
        click_on "はい"
      end
      wait_for_no_css "#recorder-#{recorder.id}"
    end
  end
end
