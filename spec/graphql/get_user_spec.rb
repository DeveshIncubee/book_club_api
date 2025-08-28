require_relative "../rails_helper"

RSpec.describe Resolvers::GetUser do
  subject(:query_ctx) { GraphQL::Query.new(BookClubApiSchema, "{ __typename }").context }
  subject(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  before(:context) do
    User.destroy_all

    @user = create(:validuser)
  end

  describe "#resolve" do
    it "returns the user by id" do
      result = resolver.resolve(id: @user.id)
      expect(result).to eq(@user)
    end

    it "returns a RecordNotFound error for non-existent user" do
      expect { resolver.resolve(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
