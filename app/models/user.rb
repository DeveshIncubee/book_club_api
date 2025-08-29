class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :reviews, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :event_attendances, dependent: :destroy
  has_many :attended_events, through: :event_attendances, source: :event
end
