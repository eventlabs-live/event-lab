class RenameRegistrationToEventRegistration < ActiveRecord::Migration[7.1]
  def change
    rename_table :registrations, :event_registrations
  end
end
