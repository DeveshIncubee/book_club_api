FactoryBot.define do
  factory :validevent do
    title { "Discussions on #{Faker::Book.title}" }
    description { Faker::Lorem.sentences }
    location { Faker::Locations::Australia.location }
    starts_at { Faker::Date.forward(days: 1, period: :morning) }
    ends_at { Faker::Date.forward(days: 1, period: :evening) }
  end
end
