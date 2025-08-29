require_relative "../rails_helper.rb"

RSpec.describe Mutations::UnattendEvent do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Event.destroy_all
    EventAttendance.destroy_all

    @host = create(:validuser, name: 'host', email: 'host@event.com')
    @user = create(:validuser, name: "user", email: "user@event.com")
    @event = create(:validevent, user_id: @host.id)

    @attendee = create(:validuser, name: 'attendee', email: 'attendee@event.com')
    @attendance = create(:attendance, user_id: @attendee.id, event_id: @event.id)
  end

  describe "#resolve" do
    context "when the input is valid" do
      let(:user_id) { @attendee.id }
      let(:event_id) { @event.id }
      let(:args) { { user_id:, event_id: } }

      it "deletes the existing event attendee" do
        expect { mutation.resolve(**args) }.to change(EventAttendance, :count).by(-1)
      end

      it "returns the old event attendee with no errors" do
        result = mutation.resolve(**args)

        expect(result[:attendee]).to be_a(EventAttendance)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the user is not already attending the event" do
      let(:attendee_id) { @user.id }
      let(:event_id) { @event.id }
      let(:args) { { user_id: attendee_id, event_id: } }

      it "does not delete any existing event attendee" do
        expect { mutation.resolve(**args) }.not_to change(EventAttendance, :count)
      end

      it "returns a validation error about user not already attending the event" do
        result = mutation.resolve(**args)

        expect(result[:attendee]).to be_nil
        expect(result[:errors]).to include("User needs to be already attending this event to unattend it")
      end
    end
  end
end
