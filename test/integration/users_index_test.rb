require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:lenneth)
  end

  test "index including pagination and users links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), email: user.email
      assert_select 'a[href=?]', user_path(user), text: 'delete'
    end
    assert_difference 'User.count', -1 do
      delete user_path(@admin)
    end
  end

end
