require_relative "../rails_helper"

RSpec.describe Mutations::CreateBook do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe "#resolve" do
    context "when the input is valid" do
      let(:title) { "Random Thoughts" }
      let(:author) { "Anon" }
      let(:genre) { "Biography" }
      let(:published_year) { 2020 }
      let(:args) { { title:, author:, genre:, published_year: } }

      it "creates a new book" do
        expect { mutation.resolve(**args) }.to change(Book, :count).by(1)
      end

      it "returns a new book with no errors" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(title:, author:, genre:, published_year:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the title is empty" do
      let(:invalid_title) { "" }
      let(:author) { "Anon" }
      let(:genre) { "Biography" }
      let(:published_year) { 2020 }
      let(:args) { { title: invalid_title, author:, genre:, published_year: } }

      it "returns a validation error about title being empty" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_nil
        expect(result[:errors]).to include("Title cannot be empty")
      end
    end

    context "when the author is empty" do
      let(:title) { "Random Thoughts" }
      let(:invalid_author) { "" }
      let(:genre) { "Biography" }
      let(:published_year) { 2020 }
      let(:args) { { title:, author: invalid_author, genre:, published_year: } }

      it "returns a validation error about author being empty" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_nil
        expect(result[:errors]).to include("Author cannot be empty")
      end
    end

    context "when the genre is empty" do
      let(:title) { "Random Thoughts" }
      let(:author) { "Anon" }
      let(:empty_genre) { "" }
      let(:published_year) { 2020 }
      let(:args) { { title:, author:, genre: empty_genre, published_year: } }

      it "creates a new book" do
        expect { mutation.resolve(**args) }.to change(Book, :count).by(1)
      end

      it "returns a new book with no errors" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(title:, author:, published_year:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the published_year is nil" do
      let(:title) { "Random Thoughts" }
      let(:author) { "Anon" }
      let(:genre) { "Biography" }
      let(:empty_published_year) { nil }
      let(:args) { { title:, author:, genre:, published_year: empty_published_year } }

      it "creates a new book" do
        expect { mutation.resolve(**args) }.to change(Book, :count).by(1)
      end

      it "returns a new book with no errors" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(title:, author:, genre:)
        expect(result[:errors]).to be_empty
      end
    end
  end
end
