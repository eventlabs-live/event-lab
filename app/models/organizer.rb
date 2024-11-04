# app/models/organizer.rb
class Organizer < ApplicationRecord
  has_many :events
  has_one_attached :avatar

  has_many :followers

  def followers_count
    followers.count
  end
end