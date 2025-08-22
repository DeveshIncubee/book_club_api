require_relative "../rails_helper"

RSpec.describe "Get Review Query", type: :request do
  let(:user) { create(:validuser) }
  let(:book) { create(:validbook) }
  let(:review) { create(:validreview, user_id: user.id, book_id: book.id) }

  def query(id:)
    <<~GQL
      query {
        review(id: #{id}) {
          id
          rating
          comment
          user {
            id
          }
          book {
            id
          }
        }
      }
    GQL
  end

  it "returns a review" do
    post "/graphql", params: { query: query(id: review.id) }
    json = JSON.parse(response.body)
    data = json["data"]["review"]

    expect(data).to include(
      "id" => review.id.to_s,
      "rating" => review.rating,
      "comment" => review.comment,
      "user" => {
        "id" => user.id.to_s
      },
      "book" => {
        "id" => book.id.to_s
      }
    )
  end
end
