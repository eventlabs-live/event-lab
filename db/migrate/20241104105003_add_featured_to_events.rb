class AddFeaturedToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :featured, :boolean
  end
end
