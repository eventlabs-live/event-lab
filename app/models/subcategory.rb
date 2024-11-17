class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :events
  validates :name, presence: true, uniqueness: { scope: :category_id }
end
