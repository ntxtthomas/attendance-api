class AttendanceEntrySerializer < ActiveModel::Serializer
  attributes :id, :student_name, :status, :recorded_at
  attribute :user_id
end