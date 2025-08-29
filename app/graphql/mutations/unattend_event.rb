module Mutations
  class UnattendEvent < BaseMutation
    argument :user_id, ID, required: true
    argument :event_id, ID, required: true

    field :attendee, Types::AttendeeType, null: true
    field :errors, [ String ], null: false

    def resolve(user_id:, event_id:)
      attendance = EventAttendance.find_by(user_id:, event_id:)

      unless attendance.nil?
        attendance.destroy

        { attendee: attendance, errors: [] }
      else
        { attendance: nil, errors: [ "User needs to be already attending this event to unattend it" ] }
      end
    end
  end
end
