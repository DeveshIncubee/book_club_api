FactoryBot.define do
  factory :validreview, class: Review do
    rating { rand(1..5) }
    comment { Faker::Lorem.paragraph }
  end
end
