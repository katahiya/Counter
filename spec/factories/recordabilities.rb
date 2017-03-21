FactoryGirl.define do
  factory :recordability do
    trait :with_record do
      after(:build) do |recordability, option|
        recordability.records << build(:record, count: 1, option: option, recordability: recordability)
      end
    end

    trait :with_records do
      after(:build) do |recordability|
        recordability.records << build(:record, count: 3, option: recordability.recorder.options.first, recordability: recordability)
        recordability.records << build(:record, count: 4, option: recordability.recorder.options.second, recordability: recordability)
        recordability.records << build(:record, count: 5, option: recordability.recorder.options.last, recordability: recordability)
      end
    end
  end
end
