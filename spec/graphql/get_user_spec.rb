require_relative "../rails_helper"

RSpec.describe "Get User Query", type: :request do
  let(:user) { create(:validuser) }

  def query(id:)
    <<~GQL
      query {
        user(id: #{id}) {
          id
          name
          email
        }
      }
    GQL
  end

  it "returns a user" do
    post "/graphql", params: { query: query(id: user.id) }
    json = JSON.parse(response.body)
    data = json["data"]["user"]

    expect(data).to include(
      "id" => user.id.to_s,
      "name" => user.name,
      "email" => user.email
    )
  end
end
