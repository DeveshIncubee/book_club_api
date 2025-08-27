require_relative "../rails_helper"

RSpec.describe Resolvers::GetUser do
  describe "#resolve" do
    let(:user) { create(:validuser) }
    let(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }

    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

    it "returns the user by id" do
      result = resolver.resolve(id: user.id)
      expect(result).to eq(user)
    end

    it "returns a RecordNotFound error for non-existent user" do
      expect { resolver.resolve(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
