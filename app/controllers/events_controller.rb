
class EventsController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!, except: [:index, :show]
  #TODO: check if all actons are needed given use of commands.
  before_action :set_event, only: [:show, :edit, :update, :destroy, :edit_status, :update_status]
  before_action :authorize_event, only: [ :edit, :update, :destroy, :edit_status, :update_status]
  before_action :authorize_new_event, only: [:new, :create]
  before_action :authorize_edit_status, only: [:edit_status, :update_status]

  def index
    @events = Event.published.order(start_date: :asc)
  end

  def show
    @ticket_types = @event.ticket_types.includes(:tickets)
    @event_registrations = @event.event_registrations.all
    @event.increment!(:clicks)
  end

  def edit_status
    render partial: 'edit_status', locals: { event: @event }
  end

  def update_status
    if @event.update(event_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("event_status_#{@event.id}", partial: "events/status", locals: { event: @event })
        end
        format.html { redirect_to @event, notice: 'Status was successfully updated.' }
      end
    else
      render partial: 'edit_status', locals: { event: @event }, status: :unprocessable_entity
    end
  end

  def new
    @event = Event.new
  end

  def create
    # @event = Event.new(event_params)
    # authorize @event
    command = Events::CreateEventCommand.new(params: event_params, organizer: current_user)
    if command.call
      redirect_to dashboard_index_path, notice: 'Event created successfully.'
    else
      flash.now[:alert] = "Invalid Data!"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    command = Events::UpdateEventCommand.call(params: event_params, organizer: current_user)
    if command.success?
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      flash.now[:alert] = "Invalid Data!"
      render :edit, status: :unprocessable_entity
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
    authorize @event
  end

  def authorize_new_event
    authorize Event
  end

  def authorize_edit_status
    authorize @event, :edit_status?
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :start_date, :end_date, :location,
      :venue, :cover_image, :status, gallery_images: [], ticket_types: [],
      ticket_types_attributes: [:name, :description, :price, :capacity]
    ).merge(id: params[:id])
  end
end