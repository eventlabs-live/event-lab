class CreateTicketTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_types do |t|
      t.string :name
      t.string :description
      t.decimal :price
      t.integer :capacity
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
