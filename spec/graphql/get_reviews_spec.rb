require_relative "../rails_helper"

RSpec.describe Resolvers::GetReviews do
  describe "#resolve" do
    let(:user) { create(:validuser) }
    let(:book) { create(:validbook) }
    let!(:reviews) { create_list(:validreview, 40, { user_id: user.id, book_id: book.id }) }
    let(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }

    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

    it "returns a list of reviews" do
      result = resolver.resolve(limit: 40)
      expect(result).to eq(reviews)
    end
  end
end
