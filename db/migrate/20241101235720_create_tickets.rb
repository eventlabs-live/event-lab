class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :ticket_type, null: false, foreign_key: true
      t.references :event_registration, null: false, foreign_key: true
      t.string :qr_code

      t.timestamps
    end
  end
end
