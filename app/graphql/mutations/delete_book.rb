module Mutations
  class DeleteBook < BaseMutation
    argument :id, ID, required: true

    field :book, Types::BookType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      book = Book.find(id)
      book.destroy

      { book:, errors: [] }
    end
  end
end
