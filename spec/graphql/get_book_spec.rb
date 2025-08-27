require_relative "../rails_helper"

RSpec.describe Resolvers::GetBook do
  describe "#resolve" do
    let(:book) { create(:validbook) }
    let(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }

    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

    it "returns the book by id" do
      result = resolver.resolve(id: book.id)
      expect(result).to eq(book)
    end

    it "returns a RecordNotFound error for non-existent book" do
      expect { resolver.resolve(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
