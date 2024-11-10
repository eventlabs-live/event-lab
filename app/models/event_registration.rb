class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  has_one_attached :ticket_pdf

  enum status: { registered: 0, attending: 1, cancelled: 2 }


end
