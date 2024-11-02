class RegistrationsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.build
  end

  def create
    @registration = Registration.new(registration_params.except(:status))
    @registration.status = Registration.statuses.key(registration_params[:status].to_i) if registration_params[:status]
    @registration.event_id = params[:event_id]
    @registration.user = current_user

    if @registration.save
      redirect_to event_registrations_path(@registration), notice: 'Registration was successfully created.'
    else
      render :new
    end
  end

  def index
    @registrations = Registration.where(event_id: event_params[:event_id])
  end

  def show
    @registration = Registration.find(params[:registration_id])
  end

  private

  def registration_params
    params.require(:registration).permit(:name, :quantity, :status).merge(event_id: params[:event_id])
  end

  def event_params
    params.permit(:event_id)
  end


end
