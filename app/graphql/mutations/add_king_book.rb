module Mutations
  class AddKingBook < BaseMutation
    argument :id, ID, required: true

    field :book, Types::BookType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      external_book = ExternalApi::KingBooksService.new.search_by_id(id)

      if external_book["data"].nil?
        return { book: nil, errors: external_book["errors"] }
      end

      data = external_book["data"]

      book = Book.new(
        title: data["title"],
        author: "Stephen King",
        genre: data["type"],
        published_year: data["year"]
      )

      if book.save
        { book:, errors: [] }
      else
        { book: nil, errors: book.errors.full_messages }
      end
    end
  end
end
