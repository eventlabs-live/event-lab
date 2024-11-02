class AddStartDateToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :start_date, :date
  end
end
