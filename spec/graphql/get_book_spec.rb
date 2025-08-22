require_relative "../rails_helper"

RSpec.describe "Get Book Query", type: :request do
  let(:book) { create(:validbook) }

  def query(id:)
    <<~GQL
      query {
        book(id: #{id}) {
          id
          title
          author
          genre
          publishedYear
        }
      }
    GQL
  end

  it "returns a book" do
    post "/graphql", params: { query: query(id: book.id) }
    json = JSON.parse(response.body)
    data = json["data"]["book"]

    expect(data).to include(
      "id" => book.id.to_s,
      "title" => book.title,
      "author" => book.author,
      "genre" => book.genre,
      "publishedYear" => book.published_year
    )
  end
end
