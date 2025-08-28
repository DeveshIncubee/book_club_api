require_relative "../rails_helper"

RSpec.describe Resolvers::GetReviews do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Book.destroy_all
    Review.destroy_all

    @user = create(:validuser)
    @book = create(:validbook)
    @reviews =  create_list(:validreview, 40, { user_id: @user.id, book_id: @book.id })
  end

  describe "#resolve" do
    it "returns a list of reviews" do
      result = resolver.resolve(limit: 40)
      expect(result).to eq(@reviews)
    end
  end
end
