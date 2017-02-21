require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_select "form[action=?]", user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    assert_select "form[action=?]", user_path(@user)
    email = "nier@valid.com"
    patch user_path(@user), params: { user: { email: email,
                                       password: "",
                                       password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to root_url
    @user.reload
    assert_equal email, @user.email
  end
end
