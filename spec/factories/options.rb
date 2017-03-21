FactoryGirl.define do
  sequence :name do |n|
    "name#{n}"
  end

  factory :option do
    name
  end
end
