require_relative "../rails_helper"

RSpec.describe Mutations::AddKingBook do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe "#resolve" do
    context "when the ID is valid" do
      let(:id) { "1" }
      let(:args) { { id: } }

      it "adds a Stephen King book" do
        expect { mutation.resolve(**args) }.to change(Book, :count).by(1)
      end

      it "returns a new book with no errors" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the ID is invalid" do
      let(:id) { "-1" }
      let(:args) { { id: } }

      it "returns an error about book not found" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_nil
        expect(result[:errors]).to include("Book not found")
      end
    end
  end
end
