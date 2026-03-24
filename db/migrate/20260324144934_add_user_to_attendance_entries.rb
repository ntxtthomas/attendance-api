class AddUserToAttendanceEntries < ActiveRecord::Migration[8.0]
  def change
    # Add the reference as nullable initially so existing rows can be backfilled.
    add_reference :attendance_entries, :user, null: true, foreign_key: true
  end
end
