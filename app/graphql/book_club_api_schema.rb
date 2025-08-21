# frozen_string_literal: true

class BookClubApiSchema < GraphQL::Schema
  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, "Record not found: #{err.message}"
  end

  rescue_from(StandardError) do |err, obj, args, ctx, field|
    Rails.logger.error(err.message)
    Rails.logger.error(err.backtrace.join("\n"))
    GraphQL::ExecutionError.new("Internal server error")
  end

  use GraphQL::Batch
  query Types::QueryType
  mutation Types::MutationType
end
