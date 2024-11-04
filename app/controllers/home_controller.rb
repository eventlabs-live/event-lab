class HomeController < ApplicationController
  def index
    @hero = Event.featured_event || Event.upcoming.first
    # @categories = Category.featured
    @events = Event.upcoming.limit(8)
    # @interests = Interest.featured
  end
end
