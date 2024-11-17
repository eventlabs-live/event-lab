# app/models/category.rb
class Category < ApplicationRecord
  has_many :subcategories, dependent: :destroy
  has_many :events
  validates :name, presence: true, uniqueness: true
end