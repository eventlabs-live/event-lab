class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.where(organizer_id: current_user).order(created_at: :desc)
  end
end
