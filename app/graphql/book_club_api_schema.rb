# frozen_string_literal: true

class BookClubApiSchema < GraphQL::Schema
  use GraphQL::Batch
  query Types::QueryType
  mutation Types::MutationType
end
