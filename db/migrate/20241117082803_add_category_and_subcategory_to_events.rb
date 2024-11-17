class AddCategoryAndSubcategoryToEvents < ActiveRecord::Migration[7.1]
  def change
    add_reference :events, :category, foreign_key: true
    add_reference :events, :subcategory, foreign_key: true
  end
end
