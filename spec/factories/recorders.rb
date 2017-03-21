FactoryGirl.define do
  factory :recorder do
    title "Test"

    factory :recorder_with_options do
      after(:create) do |recorder, evaluator|
        create_list(:option, evaluator.options_count, recorder: recorder)
      end
    end

    factory :recorder_with_recordabilies do
      after(:create) do |recorder, evaluator|
        create_list(:recordability, evaluator.recordabilities_count, recorder: recorder)
      end
    end

    factory :recorder_with_options do
      after(:create) do |recorder, evaluator|
        create_list(:record, evaluator.records_count, recorder: recorder)
      end
    end

    factory :isolated_recorder do
      title "Isolated"
    end
  end
end

