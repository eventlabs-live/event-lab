class EventRegistrationsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @event_registration = @event.event_registrations.build
  end

  def create
    @event_registration = EventRegistration.new(registration_params.except(:status))
    @event_registration.status = EventRegistration.statuses.key(registration_params[:status].to_i) if registration_params[:status]
    @event_registration.event_id = params[:event_id]
    @event_registration.user = current_user

    if @event_registration.save
      redirect_to event_event_registrations_path(@event_registration), notice: 'Event Registration was successfully created.'
    else
      render :new
    end
  end

  def index
    @event_registrations = EventRegistration.where(event_id: event_params[:event_id])
  end

  def show
    @event_registration = EventRegistration.find(params[:registration_id])
  end

  private

  def registration_params
    params.require(:event_registration).permit(:name, :quantity, :status).merge(event_id: params[:event_id])
  end

  def event_params
    params.permit(:event_id)
  end


end
