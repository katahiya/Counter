FactoryGirl.define do
  factory :user do
    email 'test@example.com'
    password 'password'
    password_confirmation 'password'

    factory :isolated_user do
      email 'isolated@example.com'
    end
  end
end
