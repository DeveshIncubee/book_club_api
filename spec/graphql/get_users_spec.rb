require_relative "../rails_helper"

RSpec.describe Resolvers::GetUsers do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    @users = build_list(:validuser, 20) do |user|
      name = Faker::Name.unique.first_name
      user.name = name
      user.email = "#{name}@test.com"
      user.save!
    end
  end

  describe "#resolve" do
    it "returns a list of users" do
      result = resolver.resolve(limit: 20)
      expect(result).to eq(@users)
    end
  end
end
