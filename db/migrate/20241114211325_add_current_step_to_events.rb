class AddCurrentStepToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :current_step, :integer
  end
end
