
class EventsController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!, except: [:index, :show]
  #TODO: check if all actons are needed given use of commands.
  before_action :set_event, only: [:show, :edit, :update, :destroy, :edit_status, :update_status]
  before_action :authorize_event, only: [ :edit, :update, :destroy, :edit_status, :update_status]
  before_action :authorize_new_event, only: [:new, :create]
  before_action :authorize_edit_status, only: [:edit_status, :update_status]

  helper_method :event_owner?

  def index
    @categories = Category.all
    if params[:category].present?
      @category = Category.find_by(name: params[:category])
      @events = @category.events.published.order(start_date: :asc)
    else
      @events = Event.published.order(start_date: :asc)
    end
    # @events = Event.published.order(start_date: :asc)
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
    puts "!!!! IN CREATE !!!!"

    command = Events::CreateEventCommand.new(params: event_params, organizer: current_user)
    if command.call
      @event = command.event
      @event.current_step = 2 # Move to next step for rendering.
      @event.save
      render turbo_stream: turbo_stream.replace("event-form-container", partial: step_partial, locals: { event: @event })
    else
      @event.current_step = 1 # Stay on the same step for rendering.
      flash.now[:alert] = "Invalid Data!"
      render turbo_stream: turbo_stream.replace("event-form-container", partial: step_partial, locals: { event: @event })
    end
  end

  def update
    puts "!!!! IN SAVE UPDATE !!!!"
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

  def save_draft
    puts "!!!! IN SAVE DRAFT !!!!"

    if params[:id].present?
      @event = Event.find(params[:id])
      @event.assign_attributes(event_params)
      @event.current_step = next_step
    else
      @event = Event.new(event_params)
    end

    if @event.save
      # render turbo_stream: turbo_stream.replace("form_step", partial: step_partial, locals: { event: @event })
      render turbo_stream: turbo_stream.replace("event-form-container", partial: step_partial, locals: { event: @event })
    else
      render turbo_stream: turbo_stream.replace("event-form-container", partial: step_partial, locals: { event: @event })
    end
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
    permitted_params = params.require(:event).permit(
      :event_type, :occasion, :start_time, :end_time,
      :title, :description, :start_date, :end_date, :location, :step, :invite_list, :budget_item,
      :venue, :cover_image, :status, gallery_images: [], ticket_types: [],
      ticket_types_attributes: [:name, :description, :price, :capacity]
    ).merge(id: params[:id])

    # Remove unnecessary parameters
    permitted_params.except(:event_type, :occasion, :start_time, :end_time, :invite_list, :budget_item)
  end

  def event_owner?
    current_user == @event.organizer
  end

  def next_step
    @event.current_step + 1
  end

  def step_partial(step = nil)
    switcher = step || @event.current_step
    case switcher
    when 1
      "events/partials/forms/step_1_basic_data"
    when 2
      "events/partials/forms/step_2_media_data"
    when 3
      "events/partials/forms/step_3_invitee_data"
    when 4
      "events/partials/forms/step_4_contact_data"
    when 5
      "events/partials/forms/step_5_budget_data"
    when 6
      "events/partials/forms/step_6_payment_data"
    when 7
      "events/partials/forms/step_7_completed"
    else
      "events/partials/forms/step_1_basic_data"
    end
  end
end