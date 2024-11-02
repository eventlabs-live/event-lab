class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :registration, null: false, foreign_key: true
      t.decimal :amount
      t.string :payment_method
      t.integer :status
      t.string :stripe_payment_intent_id

      t.timestamps
    end
  end
end
