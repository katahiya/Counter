require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:hoge)
    @non_admin = users(:lenneth)
  end

  test "layout links when not logged in" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_recorders_path(@admin), count: 0
    assert_select "a[href=?]", user_recorders_path(@non_admin), count: 0
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "layout links when logged in as non admin user" do
    log_in_as(@non_admin)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_recorders_path(@admin), count: 0
    assert_select "a[href=?]", user_recorders_path(@non_admin)
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
  end

  test "layout links when logged in as admin user" do
    log_in_as(@admin)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_recorders_path(@admin)
    assert_select "a[href=?]", user_recorders_path(@non_admin), count: 0
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
  end
end
