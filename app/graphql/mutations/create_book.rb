module Mutations
  class CreateBook < BaseMutation
    argument :title, String, required: true
    argument :author, String, required: true
    argument :genre, String, required: false
    argument :published_year, Integer, required: false

    field :book, Types::BookType, null: true
    field :errors, [ String ], null: false

    def resolve(title:, author:, genre:, published_year:)
      book = Book.create(title:, author:, genre:, published_year:)

      if book.save
        { book:, errors: [] }
      else
        if title.empty?
          { book: nil, errors: [ "Title cannot be empty" ] }
        elsif author.empty?
          { book: nil, errors: [ "Author cannot be empty" ] }
        else
          { book: nil, errors: book.errors.full_messages }
        end
      end
    end
  end
end
