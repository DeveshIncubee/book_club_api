class Event < ApplicationRecord
  belongs_to :user

  validates :title, :description, :location, presence: true

  has_many :event_attendances, dependent: :destroy
  has_many :attendees, through: :event_attendances, source: :user
end
