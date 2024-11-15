class ChangeStartDateToTimestampInEvents < ActiveRecord::Migration[7.1]
  def up
    change_column :events, :start_date, :timestamp
  end

  def down
    change_column :events, :start_date, :date
  end
end
