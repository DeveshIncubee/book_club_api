require_relative "../rails_helper.rb"

RSpec.describe Mutations::AttendEvent do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Event.destroy_all
    EventAttendance.destroy_all

    @host = create(:validuser, name: 'host', email: 'host@event.com')
    @attendee = create(:validuser, name: 'user', email: 'user@event.com')
    @event = create(:validevent, user_id: @host.id)

    @user = create(:validuser, name: 'attendee', email: 'attendee@event.com')
    @attendance = create(:attendance, user_id: @user.id, event_id: @event.id)
  end

  describe "#resolve" do
    context "when the input is valid" do
      let(:user_id) { @attendee.id }
      let(:event_id) { @event.id }
      let(:args) { { user_id:, event_id: } }

      it "creates a new event attendee" do
        expect { mutation.resolve(**args) }.to change(EventAttendance, :count).by(1)
      end

      it "returns a new event attendee with no errors" do
        result = mutation.resolve(**args)

        expect(result[:attendee]).to have_attributes(user_id:, event_id:)
        expect(result[:errors]).to be_empty
      end
    end

    context "when the user_id is invalid" do
      let(:invalid_user_id) { -1 }
      let(:event_id) { @event.id }
      let(:args) { { user_id: invalid_user_id, event_id: } }

      it "returns a validation error about user_id being invalid" do
        result = mutation.resolve(**args)

        expect(result[:attendee]).to be_nil
        expect(result[:errors]).to include("User must exist")
      end
    end

    context "when the event_id is invalid" do
      let(:user_id) { @attendee.id }
      let(:invalid_event_id) { -1 }
      let(:args) { { user_id:, event_id: invalid_event_id } }

      it "returns a validation error about event_id being invalid" do
        result = mutation.resolve(**args)

        expect(result[:attendee]).to be_nil
        expect(result[:errors]).to include("Event must exist")
      end
    end

    context "when the user is already attending the event" do
      let(:attendee_id) { @user.id }
      let(:event_id) { @event.id }
      let(:args) { { user_id: attendee_id, event_id: } }

      it "does not create a new EventAttendance" do
        expect { mutation.resolve(**args) }.not_to change(EventAttendance, :count)
      end

      it "returns a validation error about user already attending the event" do
        result = mutation.resolve(**args)

        expect(result[:attendee]).to be_nil
        expect(result[:errors]).to include("User is already attending this event")
      end
    end
  end
end
