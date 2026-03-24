require 'rails_helper'

RSpec.describe AttendanceEntry, type: :model do
  context "validations and creation" do

    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:student_name) }

    describe "creation via user" do
    let(:user) { create(:user) }

      it "is created with the correct user" do
        entry = user.attendance_entries.create!(student_name: "Sam", status: "present")
        expect(entry.user).to eq(user)
        expect(entry).to be_persisted
      end
    end

    it "is valid with student_name and status" do
      entry = create(:attendance_entry)
      expect(entry).to be_valid
    end

    it "persists and sets recorded_at when created without one" do
      entry = create(:attendance_entry)
      expect(entry).to be_persisted
      expect(entry.recorded_at).to be_present
      expect(entry.recorded_at).to be_within(5.seconds).of(Time.current)
    end

    it "is invalid without a student_name" do
      entry = AttendanceEntry.new(status: "present")
      expect(entry).not_to be_valid
      expect(entry.errors[:student_name]).to include("can't be blank")
    end

    it "is invalid with an unknown status" do
      entry = AttendanceEntry.new(student_name: "Sam", status: "not_a_status")
      expect(entry).not_to be_valid
      expect(entry.errors[:status]).to be_present
    end
  end
end
