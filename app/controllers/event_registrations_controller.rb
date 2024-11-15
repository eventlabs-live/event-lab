class EventRegistrationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_event, only: [:new, :create]
  before_action :set_request_referer , only: [:new, :create]

  def new
    @event_registration = @event.event_registrations.build
  end

  def create

    command = Registrations::CreateRegistrationCommand.call(
      params: registration_params,
      user: current_user
    )

    if command.success?
      redirect_to event_event_registrations_path(@event), notice: 'Event Registration was successfully created.'
    else
      flash.now[:alert] = "Invalid Data!"
      @event_registration = @event.event_registrations.build
      render :new, alert: 'Invalid Data!', status: :unprocessable_entity
    end
  end

  def index
    @event_registrations = EventRegistration.where(event_id: event_params[:event_id])
  end

  def show
    @event_registration = EventRegistration.find(params[:registration_id])
  end

  def booked_for
    @event_registrations = current_user.event_registrations
    # render partial: "dashboard/event_registrations"
    render partial: "event_registrations/event_bookings"
  end

  private

  def set_event
    @event = Event.find(event_params[:event_id])
  end

  def registration_params
    params.require(:event_registration).permit(:name, :quantity, :status, :ticket_type_id).tap do |whitelisted|
      whitelisted[:status] = whitelisted[:status].to_i if whitelisted[:status]
      whitelisted[:quantity] = whitelisted[:quantity].to_i if whitelisted[:quantity]
    end.merge(event_id: params[:event_id])
  end

  def event_params
    params.permit(:event_id)
  end

  def authenticate_user!
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.'
    end
  end

  def set_request_referer
    session[:previous_url] = request.referer
  end
end