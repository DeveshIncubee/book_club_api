require_relative "../rails_helper"

RSpec.describe Mutations::UpdateReview do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    Book.destroy_all
    User.destroy_all
    Review.destroy_all

    @existing_user = create(:validuser)
    @existing_book = create(:validbook)
    @existing_review = create(:validreview, user_id: @existing_user.id, book_id: @existing_book.id)
  end

  describe "#resolve" do
    context "when the input is valid" do
      let(:id) { @existing_review.id }
      let(:rating) { 5 }
      let(:comment) { "This is just a surprisingly empty comment. Thanks!" }
      let(:args) { { id:, rating:, comment: } }

      it "updates the existing review" do
        expect { mutation.resolve(**args) }.not_to change(Review, :count)
      end

      it "updates the review and returns the updated review" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_a(Review)
        expect(result[:review]).to have_attributes(rating:, comment:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the ID is invalid" do
      let(:invalid_id) { -1 }
      let(:rating) { 5 }
      let(:comment) { "This is just a surprisingly empty comment. Thanks!" }
      let(:args) { { id: invalid_id, rating:, comment: } }

      it "raises a RecordNotFound exception" do
        expect { mutation.resolve(**args) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when valid ID and valid rating are provided" do
      let(:id) { @existing_review.id }
      let(:rating) { 5 }
      let(:args) { { id:, rating: } }

      it "updates the existing review" do
        expect { mutation.resolve(**args) }.not_to change(Review, :count)
      end

      it "updates the review and returns the updated review" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_a(Review)
        expect(result[:review]).to have_attributes(rating:, comment: @existing_review.comment)
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid ID and invalid rating are provided" do
      let(:id) { @existing_review.id }
      let(:invalid_rating) { 8 }
      let(:args) { { id:, rating: invalid_rating } }

      it "returns a validation error about rating being out of range" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_nil
        expect(result[:errors]).to include("Rating must be between 1 and 5")
      end
    end

    context "when valid ID and valid comment are provided" do
      let(:id) { @existing_review.id }
      let(:comment) { "This is just a surprisingly empty comment. Thanks!" }
      let(:args) { { id:, comment: } }

      it "updates the existing review" do
        expect { mutation.resolve(**args) }.not_to change(Review, :count)
      end

      it "updates the review and returns the updated review" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_a(Review)
        expect(result[:review]).to have_attributes(rating: @existing_review.rating, comment:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid ID and empty comment are provided" do
      let(:id) { @existing_review.id }
      let(:empty_comment) { "" }
      let(:args) { { id:, comment: empty_comment } }

      it "returns a validation error about comment being empty" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_nil
        expect(result[:errors]).to include("Comment cannot be empty")
      end
    end

    context "when valid ID and non-permitted arguments are provided" do
      let(:id) { @existing_review.id }
      let(:user_id) { 3 }
      let(:book_id) { 4 }
      let(:args) { { id:, user_id:, book_id: } }

      it "returns a validation error about unpermitted arguments" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_nil
        expect(result[:errors]).to include("Unsupported arguments provided")
      end
    end
  end
end
