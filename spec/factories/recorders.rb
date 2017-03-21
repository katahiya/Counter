FactoryGirl.define do
  sequence :title do |n|
    "title#{n}"
  end

  factory :recorder do
    title

    trait :with_descendants do
      after(:create) do |recorder|
        5.times do
          recorder.options << build(:option)
        end
        3.times do
          recorder.recordabilities << build(:recordability, :with_records)
        end
      end
    end
  end
end

