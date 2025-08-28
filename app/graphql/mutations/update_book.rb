module Mutations
  class UpdateBook < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :author, String, required: false
    argument :genre, String, required: false
    argument :published_year, Integer, required: false

    field :book, Types::BookType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, **args)
      allowed_keys = [ :title, :author, :genre, :published_year ]
      unexpected_keys = args.keys - allowed_keys

      if unexpected_keys.any?
        return { user: nil, errors: [ "Unsupported arguments provided" ] }
      end

      book = Book.find(id)
      book.update(args)

      if book.save
        { book:, errors: [] }
      else
        if args.include?(:title) && args[:title].empty?
          { book: nil, errors: [ "Title cannot be empty" ] }
        elsif args.include?(:author) && args[:author].empty?
          { book: nil, errors: [ "Author cannot be empty" ] }
        else
          { book: nil, errors: book.errors.full_messages }
        end
      end
    end
  end
end
