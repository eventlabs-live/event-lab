class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :date
      t.string :location
      t.references :organizer_user, null: false, foreign_key: { to_table: :users }
      t.integer :status

      t.timestamps
    end
  end
end
