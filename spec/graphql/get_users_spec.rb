require_relative "../rails_helper"

RSpec.describe Resolvers::GetUsers do
  describe "#resolve" do
    let!(:users) {
      build_list(:validuser, 20) do |user|
        name = Faker::Name.unique.first_name
        user.name = name
        user.email = "#{name}@test.com"
        user.save!
      end
    }
    let(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }

    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

    it "returns a list of users" do
      result = resolver.resolve(limit: 20)
      expect(result).to eq(users)
    end
  end
end
