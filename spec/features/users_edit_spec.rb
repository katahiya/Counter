require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "UsersEdit", type: :feature do
  let(:user ) { create(:user, :with_descendants) }

  specify 'friendly forwarding' do
    test_friendly_forwarding(edit_user_path(user), 'form.edit_user')
  end

  specify 'ユーザー変更成功' do
    log_in_as user
    visit edit_user_path(user)
    email = "fsdawrcwerwyrew@essraercwa.com"
    password = "fsdarewgsvsarewsufuywuahfasj"
    expect(user.email).not_to eq email
    expect(user.authenticate(password)).to be false
    within("form#edit_user_#{user.id}") do
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_button '変更'
    end
    user.reload
    expect(user.email).to eq email
    expect(user.authenticate(password)).not_to be false
    check_alert_seccess
  end

  specify 'ユーザー変更失敗時にエラーを出力する' do
    log_in_as user
    visit edit_user_path(user)
    within("form#edit_user_#{user.id}") do
      fill_in 'user[email]', with: ""
      click_button '変更'
    end
    expect(page).to have_css "#error_explanation"
  end
end
