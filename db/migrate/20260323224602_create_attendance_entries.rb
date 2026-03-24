class CreateAttendanceEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_entries do |t|
      t.string :student_name
      t.string :status
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
