module Mutations
  class AttendEvent < BaseMutation
    argument :user_id, ID, required: true
    argument :event_id, ID, required: true

    field :attendee, Types::AttendeeType, null: true
    field :errors, [ String ], null: false

    def resolve(user_id:, event_id:)
      if EventAttendance.where(user_id:, event_id:).any?
        return { attendance: nil, errors: [ "User is already attending this event" ] }
      end

      attendance = EventAttendance.create(user_id:, event_id:)

      if attendance.save
        { attendee: attendance, errors: [] }
      else
        { attendance: nil, errors: attendance.errors.full_messages }
      end
    end
  end
end
