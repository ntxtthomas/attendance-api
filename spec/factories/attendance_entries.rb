FactoryBot.define do
  factory :attendance_entry do
    association :user
    student_name { Faker::Name.name }
    status { "present" }
    recorded_at { nil }
  end
end
