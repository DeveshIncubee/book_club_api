require_relative "../rails_helper.rb"

RSpec.describe Mutations::DeleteBook do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    Book.destroy_all

    @book = create(:validbook)
  end

  describe "#resolve" do
    context "when the ID is valid" do
      let(:id) { @book.id }
      let(:args) { { id: } }

      it "deletes the existing book" do
        expect { mutation.resolve(**args) }.to change(Book, :count).by(-1)
      end

      it "returns the deleted book with no errors" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
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
