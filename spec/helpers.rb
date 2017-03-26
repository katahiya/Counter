module Helpers
  def log_in_as(user)
    visit login_path
    within('form#sessions_new') do
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end
    wait_for_no_css 'form#sessions_new'
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

  def wait_for_content(content)
    until has_content?(content); end
    expect(page).to have_content content
  end

  def wait_for_no_css(content)
    until has_no_content?(content); end
    expect(page).not_to have_content content
  end

  def wait_for_css(selector, visible: true)
    until has_css?(selector, visible: visible); end
    find(selector, visible: visible)
  end

  def wait_for_no_css(selector, visible: true)
    until has_no_css?(selector, visible: visible); end
    expect(page).not_to have_css selector, visible: visible
  end
end
