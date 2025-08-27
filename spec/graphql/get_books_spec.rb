require_relative "../rails_helper"

RSpec.describe Resolvers::GetBooks do
  describe "#resolve" do
    let!(:books) { create_list(:validbook, 40) }
    let(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }

    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

    it "returns a list of books" do
      result = resolver.resolve(limit: 40)
      expect(result).to eq(books)
    end
  end
end
