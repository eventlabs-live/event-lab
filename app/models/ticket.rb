class Ticket < ApplicationRecord
  belongs_to :ticket_type
  belongs_to :registration
end
