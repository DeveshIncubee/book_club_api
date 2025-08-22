FactoryBot.define do
  factory :validuser, class: User do
    name { "John" }
    email { "john@doe.com" }
  end

  factory :nameemptyuser, class: User do
    name { "" }
    email { "jane@doe.com" }
  end
end
