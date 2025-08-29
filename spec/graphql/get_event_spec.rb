require_relative "../rails_helper"

RSpec.describe Resolvers::GetEvent do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Event.destroy_all

    @user = create(:validuser)
    @event = create(:validevent, user_id: @user.id)
  end

  describe "#resolve" do
    it "returns the event by id" do
      result = resolver.resolve(id: @event.id)
      expect(result).to eq(@event)
    end

    it "returns a RecordNotFound error for non-existent event" do
      expect { resolver.resolve(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
