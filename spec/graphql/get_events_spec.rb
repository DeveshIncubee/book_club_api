require_relative "../rails_helper"

RSpec.describe Resolvers::GetEvents do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all
    Event.destroy_all

    @user = create(:validuser)
    @events =  create_list(:validevent, 5, { user_id: @user.id })
  end

  describe "#resolve" do
    it "returns a list of events" do
      result = resolver.resolve(limit: 5)
      expect(result).to eq(@events)
    end
  end
end
