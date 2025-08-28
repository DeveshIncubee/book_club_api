require_relative "../rails_helper"

RSpec.describe Mutations::UpdateUser do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    @existing_user = create(:validuser)
  end

  describe "#resolve" do
    context "when the input is valid" do
      let(:id) { @existing_user.id }
      let(:name) { "John" }
      let(:email) { "john@test.com" }
      let(:args) { { id:, name:, email: } }

      it "updates the existing user" do
        expect { mutation.resolve(**args) }.not_to change(User, :count)
      end

      it "updates the user and returns the updated user" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_a(User)
        expect(result[:user]).to have_attributes(name:, email:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the ID is invalid" do
      let(:invalid_id) { -1 }
      let(:name) { "John" }
      let(:email) { "john@test.com" }
      let(:args) { { id: invalid_id, name:, email: } }

      it "raises a RecordNotFound exception" do
        expect { mutation.resolve(**args) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when valid ID and valid name are provided" do
      let(:id) { @existing_user.id }
      let(:name) { "John" }
      let(:args) { { id:, name: } }

      it "updates the existing user" do
        expect { mutation.resolve(**args) }.not_to change(User, :count)
      end

      it "updates the user and returns the updated user" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_a(User)
        expect(result[:user]).to have_attributes(name:, email: @existing_user.email)
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid valid ID and empty name are provided" do
      let(:id) { @existing_user.id }
      let(:empty_name) { "" }
      let(:args) { { id:, name: empty_name } }

      it "returns a validation error about name being empty" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Name cannot be empty")
      end
    end

    context "when valid ID and valid email are provided" do
      let(:id) { @existing_user.id }
      let(:email) { "john@doe.com" }
      let(:args) { { id:, email: } }

      it "updates the existing user" do
        expect { mutation.resolve(**args) }.not_to change(User, :count)
      end

      it "updates the user and returns the updated user" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_a(User)
        expect(result[:user]).to have_attributes(name: @existing_user.name, email:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when valid ID and empty email are provided" do
      let(:id) { @existing_user.id }
      let(:empty_email) { "" }
      let(:args) { { id:, email: empty_email } }

      it "returns a validation error about email being empty" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Email cannot be empty")
      end
    end

    context "when valid ID and invalid email are provided" do
      let(:id) { @existing_user.id }
      let(:invalid_email) { "johndoe.com" }
      let(:args) { { id:, email: invalid_email } }

      it "returns a validation error about email being invalid" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Provide valid email")
      end
    end

    context "when valid ID and non-permitted arguments are provided" do
      let(:id) { @existing_user.id }
      let(:title) { "Jane" }
      let(:author) { "jane@doe.com" }
      let(:args) { { id:, title:, author: } }

      it "returns a validation error about unpermitted arguments" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Unsupported arguments provided")
      end
    end
  end
end
