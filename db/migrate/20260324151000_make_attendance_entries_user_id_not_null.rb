class MakeAttendanceEntriesUserIdNotNull < ActiveRecord::Migration[8.0]
  def up
    # Ensure no NULLs present before enforcing constraint
    execute <<-SQL.squish
      DELETE FROM attendance_entries WHERE id IS NULL;
    SQL

    change_column_null :attendance_entries, :user_id, false
  end

  def down
    change_column_null :attendance_entries, :user_id, true
  end
end
