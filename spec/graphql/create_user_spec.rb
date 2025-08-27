require_relative "../rails_helper"

RSpec.describe Mutations::CreateUser do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe "#resolve" do
    context "when the input is valid" do
      let(:name) { "John" }
      let(:email) { "john@test.com" }
      let(:args) { { name:, email: } }

      it "creates a new user" do
        expect { mutation.resolve(**args) }.to change(User, :count).by(1)
      end

      it "returns a new user with no errors" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_a(User)
        expect(result[:user]).to have_attributes(name:, email:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the name is empty" do
      let(:invalid_name) { "" }
      let(:email) { "john@test.com" }
      let(:args) { { name: invalid_name, email: } }

      it "returns a validation error about name being empty" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Name cannot be empty")
      end
    end

    context "when the email is empty" do
      let(:name) { "John" }
      let(:invalid_email) { "" }
      let(:args) { { name:, email: invalid_email } }

      it "returns a validation error about email being empty" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Email cannot be empty")
      end
    end

    context "when the email is invalid" do
      let(:name) { "John" }
      let(:invalid_email) { "john.com" }
      let(:args) { { name:, email: invalid_email } }

      it "returns a validation error about email being invalid" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Provide valid email")
      end
    end

    context "when the email is already taken" do
      before { create(:validuser, name: "John", email: "john@test.com") }

      let(:name) { "Jane" }
      let(:email) { "john@test.com" }
      let(:args) { { name:, email: } }

      it "returns a validation error about the unique attribute" do
        result = mutation.resolve(**args)

        expect(result[:user]).to be_nil
        expect(result[:errors]).to include("Email has already been taken")
      end
    end
  end
end
