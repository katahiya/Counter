FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :user do
    email
    password 'password'
    password_confirmation 'password'

    trait :with_descendants do
      after(:create) do |user|
        4.times do
          user.recorders << build(:recorder, :with_descendants)
        end
      end
    end

  end
end
