class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all
  end

  def show
    @ticket = Ticket.find(params[:id])
    @qr = RQRCode::QRCode.new(ticket_url(@ticket))
  end

  def new
  end

  def create
  end
end
