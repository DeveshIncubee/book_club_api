class Event < ApplicationRecord
  belongs_to :user

  validates :title, :description, :location, presence: true
end
