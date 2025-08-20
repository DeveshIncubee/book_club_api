module Mutations
  class UpdateBook < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: true
    argument :author, String, required: true
    argument :genre, String, required: true
    argument :published_year, Integer, required: true

    field :book, Types::BookType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, title:, author:, genre:, published_year:)
      book = Book.find(id)
      book.update(title:, author:, genre:, published_year:)

      if book.save
        { book:, errors: [] }
      else
        { book: nil, errors: book.errors.full_messages }
      end
    end
  end
end
