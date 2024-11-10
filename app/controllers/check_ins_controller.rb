class CheckInsController < ApplicationController
  def create
    pp params
    bc = JSON.parse(params.require(:barcode))
    p bc["barcode_uuid"]
    qr = bc["barcode_uuid"]
    p qr
    @ticket = Ticket.find_by(qr_code: qr)
    if @ticket
      @ticket.event_registration.update(status: :attended)
      render json: { success: true }
    else
      render json: { success: false }, status: :not_found
    end
  end

  def qr_params
    params.require(:barcode).permit!.to_h
  end
end
