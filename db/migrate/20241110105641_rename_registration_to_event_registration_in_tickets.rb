class RenameRegistrationToEventRegistrationInTickets < ActiveRecord::Migration[7.1]
  def change
    rename_column :tickets, :registration_id, :event_registration_id
  end
end
