FactoryBot.define do
  factory :validbook, class: Book  do
    title { Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    published_year { Faker::Number.between(from: 1900, to: Time.current.year) }
  end
end
