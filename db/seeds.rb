# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
def seed_categories_and_subcategories
  categories = {
    'Entertainment' => ['Concert', 'Music festival', 'Theater performance', 'Comedy show', 'Dance performance', 'Film screening'],
    'Sports' => ['Professional sports matche', 'Amateur tournament', 'Racing event', 'Marathon and fun run'],
    'Business and Professional' => ['Conference', 'Seminar', 'Trade show', 'Networking', 'Workshop'],
    'Cultural and Community' => ['Art exhibition', 'Food and wine festival', 'Cultural celebration', 'Charity event', 'Fairs and carnival'],
    'Educational' => ['Lecture', 'Webinar', 'Training session', 'Academic conference'],
    'Social' => ['Wedding', 'Birthday party', 'Reunion', 'Gala and fundraiser']
  }

  categories.each do |category_name, subcategories|
    category = Category.create!(name: category_name)
    subcategories.each do |subcategory_name|
      Subcategory.create!(name: subcategory_name, category: category)
    end
  end
end