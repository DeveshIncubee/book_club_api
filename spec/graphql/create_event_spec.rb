require_relative "../rails_helper.rb"

RSpec.describe Mutations::CreateEvent do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all

    @user = create(:validuser)
  end

  describe "#resolve" do
    context "when the input is valid" do
      let(:title) { "Discuss Clean Code" }
      let(:description) { "To discuss the Clean Code book, duh" }
      let(:location) { "Mumbai" }
      let(:starts_at) { Faker::Time.forward(days: 1, period: :morning) }
      let(:ends_at) { Faker::Time.forward(days: 1, period: :evening) }
      let(:user_id) { @user.id }
      let(:args) { { title:, description:, location:, starts_at:, ends_at:, user_id: } }

      it "creates a new event" do
        expect { mutation.resolve(**args) }.to change(Event, :count).by(1)
      end

      it "returns a new event with no errors" do
        result = mutation.resolve(**args)

        expect(result[:event]).to be_a(Event)
        expect(result[:event]).to have_attributes(title:, description:, location:, starts_at:, ends_at:, user_id:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the title is empty" do
      let(:empty_title) { "" }
      let(:description) { "To discuss the Clean Code book, duh" }
      let(:location) { "Mumbai" }
      let(:starts_at) { Faker::Time.forward(days: 1, period: :morning) }
      let(:ends_at) { Faker::Time.forward(days: 1, period: :evening) }
      let(:user_id) { @user.id }
      let(:args) { { title: empty_title, description:, location:, starts_at:, ends_at:, user_id: } }

      it "returns a validation error about title being empty" do
        result = mutation.resolve(**args)

        expect(result[:event]).to be_nil
        expect(result[:errors]).to include("Title cannot be empty")
      end
    end
  end
end
