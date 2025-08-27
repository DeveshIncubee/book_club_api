require_relative "../rails_helper"

RSpec.describe Mutations::CreateReview do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe "#resolve" do
    let(:user) { create(:validuser) }
    let(:book) { create(:validbook) }

    context "when the input is valid" do
      let(:rating) { 5 }
      let(:comment) { "Great stuff" }
      let(:book_id) { book.id }
      let(:user_id) { user.id }
      let(:args) { { rating:, comment:, book_id:, user_id: } }

      it "creates a new review" do
        expect { mutation.resolve(**args) }.to change(Review, :count).by(1)
      end

      it "returns a new review with no errors" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_a(Review)
        expect(result[:review]).to have_attributes(rating:, comment:, book_id:, user_id:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the rating is invalid" do
      let(:invalid_rating) { 6 }
      let(:comment) { "Great stuff" }
      let(:book_id) { book.id }
      let(:user_id) { user.id }
      let(:args) { { rating: invalid_rating, comment:, book_id:, user_id: } }

      it "returns a validation error about rating being invalid" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_nil
        expect(result[:errors]).to include("Rating must be between 1 and 5")
      end
    end

    context "when the comment is empty" do
      let(:rating) { 2 }
      let(:empty_comment) { "" }
      let(:book_id) { book.id }
      let(:user_id) { user.id }
      let(:args) { { rating:, comment: empty_comment, book_id:, user_id: } }

      it "returns a validation error about comment being empty" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_nil
        expect(result[:errors]).to include("Comment cannot be empty")
      end
    end
  end
end
