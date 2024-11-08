class HomeController < ApplicationController
  def index
    @hero = Event.featured_events.first || Event.upcoming.first
    # @categories = Category.featured
    @events = Event.upcoming.limit(8)
    @trending_events = Event.trending.limit(4)
    # @interests = Interest.featured
  end
end
