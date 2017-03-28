require 'rails_helper'
require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.feature "LoginAndLogouts", type: :feature do
  let(:user ) { create(:user, :with_descendants) }

  specify 'ユーザー認証成功' do
    visit login_path
    expect(page).to have_link nil, href: login_path
    expect(page).not_to have_link nil, href: logout_path, visible: false
    within('form#sessions_new') do
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end
    expect(page).not_to have_css('form#sessions_new')
    expect(page).not_to have_link nil, href: login_path
    expect(page).to have_link nil, href: logout_path, visible: false
    expect(logged_in?).to be true
  end

  specify 'ユーザー認証失敗時にエラーを出力する' do
    visit login_path
    wrong_email = "wrong@example.com"
    expect(user.email).not_to eq wrong_email
    within('form#sessions_new') do
      fill_in 'session[email]', with: wrong_email
      fill_in 'session[password]', with: 'wrong_password'
      click_button 'ログイン'
    end
    within "#flash_messages" do
      expect(page).to have_css('div.alert')
    end
    expect(page).to have_css('form#sessions_new')
    expect(page).to have_link nil, href: login_path
    expect(page).not_to have_link nil, href: logout_path, visible: false
    expect(logged_in?).to be false
  end

  specify 'ログアウト' do
    log_in_as user
    visit root_path
    expect(page).not_to have_link nil, href: login_path
    expect(page).to have_link nil, href: logout_path, visible: false
    find('.dropdown-toggle').click
    click_on "ログアウト"
    expect(page).to have_link nil, href: login_path
    expect(page).not_to have_link nil, href: logout_path, visible: false
    expect(logged_in?).to be false
  end
end
