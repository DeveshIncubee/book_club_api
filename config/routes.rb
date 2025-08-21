Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/graphql", to: "graphql#execute"

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
