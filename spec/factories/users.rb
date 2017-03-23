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
          user.recorders << create(:recorder, :with_descendants, user: user)
        end
      end
    end

    trait :with_paginate do
      after(:create) do |user|
        100.times do
          user.recorders << create(:recorder, user: user)
        end
      end
    end
  end
end
