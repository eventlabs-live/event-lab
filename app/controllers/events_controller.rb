require_relative '../../app/commands/events/create_event_command'
class EventsController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_event, only: [:new, :create, :edit, :update, :destroy]

  def index
    @events = Event.published.order(start_date: :asc)
  end

  def show
    @ticket_types = @event.ticket_types.includes(:tickets)
    @registrations = @event.registrations.all
  end

  def new
    @event = Event.new
  end

  def create
    command = CreateEventCommand.new(params: event_params, organizer: current_user)
    if command.call

      redirect_to dashboard_index_path, notice: 'Event created successfully.'
    else
      flash.now[:alert] = "Invalid Data!"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private

  def set_event
    @event = Event.find_by_id(params[:id])
    redirect_to events_path, alert: 'Event not found.' unless @event
  end

  def authorize_event
    authorize Event
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :start_date, :end_date, :location,
      :venue, :cover_image, gallery_images: [], ticket_types: [],
      ticket_types_attributes: [:name, :description, :price, :capacity]
    )
  end
end