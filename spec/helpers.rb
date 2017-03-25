module Helpers
  def log_in_as(user)
    visit login_path
    within('form#sessions_new') do
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end
    expect(page).not_to have_css('form#sessions_new')
  end

  def test_friendly_forwarding(url, selector)
    visit url
    expect(page).not_to have_css(selector)
    within('form#sessions_new') do
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end
    expect(page).not_to have_css('form#sessions_new')
    expect(page).to have_css(selector)
  end
end
