FactoryBot.define do
  factory :validbook, class: Book  do
    title { "Little Selves" }
    author { "Mary Lerner" }
    genre { "Short Story" }
    published_year { 1916 }
  end
end
