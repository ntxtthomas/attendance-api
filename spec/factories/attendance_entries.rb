FactoryBot.define do
  factory :attendance_entry do
    student_name { Faker::Name.name }
    status { AttendanceEntry::STATUSES.values.sample }
  end
end
