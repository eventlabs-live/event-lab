class TicketType < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy
  monetize :price, as: "price_cents"
  validates :name, :price, :capacity, presence: true
  # validate :capacity_within_venue_limit

  def available?
    tickets.count < capacity
  end

  def current_price
    # Dynamic pricing logic based on time/availability
    return price if tickets.count < (capacity * 0.5)
    price * 1.2 # 20% increase after 50% sold
  end

  def self.default(event)
    where(name: 'DEFAULT').first_or_create(event_id: event, name: 'DEFAULT', price: 0, capacity: 100)
  end
end
