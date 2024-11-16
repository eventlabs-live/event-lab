class TicketsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user
      @tickets = Ticket.where(user_id: current_user.id)
      @event_registrations = EventRegistration.where(user_id: current_user.id)
    else
      @tickets = Ticket.all
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
    @qr = RQRCode::QRCode.new(ticket_url(@ticket))
  end

  def new
  end

  def create
  end
  private
  def authenticate_user!
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.'
    end
  end
end
