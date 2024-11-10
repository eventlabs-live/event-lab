class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @organised_events = Event.where(organizer_id: current_user).order(start_date: :desc)
    @event_registrations = current_user.event_registrations.includes(:event).order('events.start_date ASC')
  end
end
