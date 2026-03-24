class AttendanceEntry < ApplicationRecord

    belongs_to :user

    before_validation :set_recorded_at, on: :create

    belongs_to :user, optional: true

    STATUSES = { present: "present", absent: "absent", late: "late", excused: "excused" }.freeze

    validates :status, presence: true, inclusion: { in: STATUSES.values }
    validates :recorded_at, presence: true
    validates :student_name, presence: true

    def set_recorded_at
        self.recorded_at ||= Time.current
    end
end
