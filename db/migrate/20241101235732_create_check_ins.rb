class CreateCheckIns < ActiveRecord::Migration[7.1]
  def change
    create_table :check_ins do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :checked_by, polymorphic: true, null: false
      t.datetime :timestamp

      t.timestamps
    end
  end
end
