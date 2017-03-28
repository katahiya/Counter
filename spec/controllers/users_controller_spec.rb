require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user ) { create(:user, :with_descendants) }

  specify 'postに含まれるadminは無視される' do
    email = "vuasihfefhvdfkhahdfhskjaf@example.com"
    post :create, user: { email: email,
                          password: "password",
                          password_confirmation: "password",
                          admin: true  }
    expect(User.last.email).to eq email
    expect(User.last.admin?).to be false
  end

  specify 'postに含まれるadminは無視される' do
    patch :update, id: user, user: { email: user.email,
                             password: "password",
                             admin: true  }
    user.reload
    expect(user.admin?).to be false
  end
end
