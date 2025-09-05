# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'faker'

10.times do
  name = Faker::Name.unique.first_name
  User.create(name: name, email: "#{name.downcase}@test.com")
end

20.times do
  Book.create(
    title: Faker::Book.title,
    author: Faker::Book.author,
    genre: Faker::Book.genre,
    published_year: Faker::Number.between(from: 1900, to: Time.current.year
  )
)
end

40.times do
  Review.create(
    rating: rand(1..5),
    comment: Faker::Lorem.paragraph,
    user_id: rand(1..10),
    book_id: rand(1..20)
  )
end

# Seed Events
15.times do
  Event.create(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    starts_at: Faker::Time.forward(days: 60, period: :day),
    ends_at: Faker::Time.forward(days: 60, period: :day) + rand(1..5).hours,
    location: Faker::Address.full_address,
    user_id: User.all.sample.id
  )
end

# Seed EventAttendances
# Ensure there are enough users and events to create attendances
users = User.all
events = Event.all

if users.any? && events.any?
  30.times do
    user = users.sample
    event = events.sample
    # Ensure uniqueness if needed, though for seeding, it might not be strictly necessary
    # depending on the model's validations. For simplicity, we'll just create.
    EventAttendance.find_or_create_by(user: user, event: event)
  end
end
