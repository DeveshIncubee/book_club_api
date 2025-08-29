# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :user, resolver: Resolvers::GetUser
    field :users, resolver: Resolvers::GetUsers

    field :book, resolver: Resolvers::GetBook
    field :books, resolver: Resolvers::GetBooks

    field :review, resolver: Resolvers::GetReview
    field :reviews, resolver: Resolvers::GetReviews

    field :event, resolver: Resolvers::GetEvent
  end
end
