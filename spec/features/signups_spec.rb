require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "Signups", type: :feature do
  specify 'ユーザー認証成功' do
    expect {
      visit signup_path
      email = "fsdawrcwerwyrew@essraercwa.com"
      within('form#new_user') do
        fill_in 'user[email]', with: email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'サインアップ'
      end
      expect(logged_in?).to be true
      expect(remember?).to be false
    }.to change { User.count }.by(1)
  end

  specify 'ユーザー認証失敗時にエラーを出力する' do
    expect {
      visit signup_path
      within('form#new_user') do
        click_button 'サインアップ'
      end
      expect(page).to have_css "#error_explanation"
      expect(logged_in?).to be false
    }.not_to change { User.count }
  end

end
