FactoryGirl.define do
  sequence :title do |n|
    "title#{n}"
  end

  factory :recorder do
    title

    trait :with_descendants do
      after(:create) do |recorder|
        5.times do
          recorder.options << create(:option, recorder: recorder)
        end
        3.times do
          recorder.recordabilities << create(:recordability, :with_records, recorder: recorder)
        end
      end
    end
  end
end

