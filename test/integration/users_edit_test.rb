require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @other_user = users(:lenneth)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    email = "nier@valid.com"
    patch user_path(@user), params: { user: { email: email,
                                       password: "",
                                       password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to root_url
    @user.reload
    assert_equal email, @user.email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    email = "nier@valid.com"
    patch user_path(@user), params: { user: { email: email,
                                       password: "",
                                       password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    email = "nier@valid.com"
    patch user_path(@user), params: { user: { email: email,
                                       password: "",
                                       password_confirmation: "" } }
    assert_redirected_to root_url
  end
end
