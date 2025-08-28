require_relative "../rails_helper"

RSpec.describe Resolvers::GetReview do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Book.destroy_all
    Review.destroy_all

    @user = create(:validuser)
    @book = create(:validbook)
    @review = create(:validreview, user_id: @user.id, book_id: @book.id)
  end

  describe "#resolve" do
    it "returns the review by id" do
      result = resolver.resolve(id: @review.id)
      expect(result).to eq(@review)
    end

    it "returns a RecordNotFound error for non-existent review" do
      expect { resolver.resolve(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
