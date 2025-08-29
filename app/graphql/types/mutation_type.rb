# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :delete_user, mutation: Mutations::DeleteUser

    field :create_book, mutation: Mutations::CreateBook
    field :update_book, mutation: Mutations::UpdateBook
    field :delete_book, mutation: Mutations::DeleteBook

    field :create_review, mutation: Mutations::CreateReview
    field :update_review, mutation: Mutations::UpdateReview
    field :delete_review, mutation: Mutations::DeleteReview

    field :create_event, mutation: Mutations::CreateEvent
    field :delete_event, mutation: Mutations::DeleteEvent
    field :attend_event, mutation: Mutations::AttendEvent
    field :unattend_event, mutation: Mutations::UnattendEvent
  end
end
