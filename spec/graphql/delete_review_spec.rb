require_relative "../rails_helper.rb"

RSpec.describe Mutations::DeleteReview do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Book.destroy_all
    Review.destroy_all

    @user = create(:validuser)
    @book = create(:validbook)
    @review = create(:validreview, user_id: @user.id, book_id: @book.id)
  end

  describe "#resolve" do
    context "when the ID is valid" do
      let(:id) { @review.id }
      let(:args) { { id: } }

      it "deletes the existing review" do
        expect { mutation.resolve(**args) }.to change(Review, :count).by(-1)
      end

      it "returns the deleted review with no errors" do
        result = mutation.resolve(**args)

        expect(result[:review]).to be_a(Review)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the ID is invalid" do
      let(:invalid_id) { 101 }
      let(:args) { { id: invalid_id } }

      it "raises a RecordNotFound exception" do
        expect { mutation.resolve(**args) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
