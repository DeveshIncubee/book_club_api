module Resolvers
  class GetEvent < BaseResolver
    type Types::EventType, null: false
    description "Fetch a event given its ID."

    argument :id, ID, required: true, description: "ID of the event."

    def resolve(id:)
      Event.find(id)
    end
  end
end
