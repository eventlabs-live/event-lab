class AddTicketToEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_reference :event_registrations, :ticket, null: true, foreign_key: true
  end
end
