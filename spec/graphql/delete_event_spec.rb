require_relative "../rails_helper.rb"

RSpec.describe Mutations::DeleteEvent do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Event.destroy_all

    @user = create(:validuser)
    @event = create(:validevent, user_id: @user.id)
  end

  describe "#resolve" do
    context "when the ID is valid" do
      let(:id) { @event.id }
      let(:args) { { id: } }

      it "deletes the existing event" do
        expect { mutation.resolve(**args) }.to change(Event, :count).by(-1)
      end

      it "returns the deleted event with no errors" do
        result = mutation.resolve(**args)

        expect(result[:event]).to be_a(Event)
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
