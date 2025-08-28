require_relative "../rails_helper"

RSpec.describe Resolvers::GetBooks do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    Book.destroy_all

    @books = create_list(:validbook, 40)
  end

  describe "#resolve" do
    it "returns a list of books" do
      result = resolver.resolve(limit: 40)
      expect(result).to eq(@books)
    end
  end
end
