class AddClicksToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :clicks, :integer
  end
end
