require_relative "../rails_helper"

RSpec.describe Mutations::UpdateBook do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    Book.destroy_all
    @existing_book = create(:validbook)
  end

  describe "#resolve" do
    context "when the input is valid" do
      let(:id) { @existing_book.id }
      let(:title) { "Random Thoughts" }
      let(:author) { "Anon" }
      let(:genre) { "Biography" }
      let(:published_year) { 2015 }
      let(:args) { { id:, title:, author:, genre:, published_year: } }

      it "updates the existing book" do
        expect { mutation.resolve(**args) }.not_to change(Book, :count)
      end

      it "updates the book and returns the updated book" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(title:, author:, genre:, published_year:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the ID is invalid" do
      let(:invalid_id) { -1 }
      let(:title) { "Random Thoughts" }
      let(:author) { "Anon" }
      let(:genre) { "Biography" }
      let(:published_year) { 2015 }
      let(:args) { { id: invalid_id, title:, author:, genre:, published_year: } }

      it "raises a RecordNotFound exception" do
        expect { mutation.resolve(**args) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when valid ID and valid title are provided" do
      let(:id) { @existing_book.id }
      let(:title) { "Random Thoughts" }
      let(:args) { { id:, title: } }

      it "updates the existing book" do
        expect { mutation.resolve(**args) }.not_to change(Book, :count)
      end

      it "updates the book and returns the updated book" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(
          title:,
          author: @existing_book.author,
          genre: @existing_book.genre,
          published_year: @existing_book.published_year
        )
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid valid ID and empty title are provided" do
      let(:id) { @existing_book.id }
      let(:empty_title) { "" }
      let(:args) { { id:, title: empty_title } }

      it "returns a validation error about title being empty" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_nil
        expect(result[:errors]).to include("Title cannot be empty")
      end
    end

    context "when valid ID and valid author are provided" do
      let(:id) { @existing_book.id }
      let(:author) { "Anon" }
      let(:args) { { id:, author: } }

      it "updates the existing book" do
        expect { mutation.resolve(**args) }.not_to change(Book, :count)
      end

      it "updates the book and returns the updated book" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(
          title: @existing_book.title,
          author:,
          genre: @existing_book.genre,
          published_year: @existing_book.published_year
        )
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid valid ID and empty author are provided" do
      let(:id) { @existing_book.id }
      let(:empty_author) { "" }
      let(:args) { { id:, author: empty_author } }

      it "returns a validation error about author being empty" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_nil
        expect(result[:errors]).to include("Author cannot be empty")
      end
    end

    context "when valid ID and valid genre are provided" do
      let(:id) { @existing_book.id }
      let(:genre) { "Biography" }
      let(:args) { { id:, genre: } }

      it "updates the existing book" do
        expect { mutation.resolve(**args) }.not_to change(Book, :count)
      end

      it "updates the book and returns the updated book" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(
          title: @existing_book.title,
          author: @existing_book.author,
          genre:,
          published_year: @existing_book.published_year
        )
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid valid ID and empty genre are provided" do
      let(:id) { @existing_book.id }
      let(:empty_genre) { "" }
      let(:args) { { id:, genre: empty_genre } }

      it "updates the existing book" do
        expect { mutation.resolve(**args) }.not_to change(Book, :count)
      end

      it "updates the book and returns the updated book" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(
          title: @existing_book.title,
          author: @existing_book.author,
          genre: empty_genre,
          published_year: @existing_book.published_year
        )
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid ID and valid published year are provided" do
      let(:id) { @existing_book.id }
      let(:published_year) { 2015 }
      let(:args) { { id:, published_year: } }

      it "updates the existing book" do
        expect { mutation.resolve(**args) }.not_to change(Book, :count)
      end

      it "updates the book and returns the updated book" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_a(Book)
        expect(result[:book]).to have_attributes(
          title: @existing_book.title,
          author: @existing_book.author,
          genre: @existing_book.genre,
          published_year:
        )
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid ID and non-permitted arguments are provided" do
      let(:id) { @existing_book.id }
      let(:name) { "Jane" }
      let(:email) { "jane@doe.com" }
      let(:args) { { id:, name:, email: } }

      it "returns a validation error about unpermitted arguments" do
        result = mutation.resolve(**args)

        expect(result[:book]).to be_nil
        expect(result[:errors]).to include("Unsupported arguments provided")
      end
    end
  end
end
