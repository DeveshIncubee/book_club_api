FactoryBot.define do
  factory :attendance, class: EventAttendance do
    user_id { nil }
    event_id { nil }
  end
end
