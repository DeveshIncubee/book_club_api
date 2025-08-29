module Resolvers
  class GetEvents < BaseResolver
    type [ Types::EventType ], null: false
    description "Return a list of events."

    argument :limit, Integer, required: false, description: "Limit of the events.", default_value: 4

    def resolve(limit:)
      Event.limit(limit)
    end
  end
end
