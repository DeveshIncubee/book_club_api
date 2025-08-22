FactoryBot.define do
  factory :validreview, class: Review do
    rating { 4 }
    comment { "Life-changing experience" }
  end
end
