require_relative "../rails_helper"

RSpec.describe Resolvers::GetReview do
  describe "#resolve" do
    let(:user) { create(:validuser) }
    let(:book) { create(:validbook) }
    let(:review) { create(:validreview, user_id: user.id, book_id: book.id) }
    let(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }

    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

    it "returns the review by id" do
      result = resolver.resolve(id: review.id)
      expect(result).to eq(review)
    end

    it "returns a RecordNotFound error for non-existent review" do
      expect { resolver.resolve(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
