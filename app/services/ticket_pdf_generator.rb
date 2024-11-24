# app/services/ticket_pdf_generator.rb
require 'prawn'
require 'rqrcode'

class TicketPdfGenerator
  def initialize(registration, ticket_type_id)
    @registration = registration
    @event = registration.event
    @user = registration.user
    @ticket_type = TicketType.find(ticket_type_id)
  end

  def generate
    pdf_content = Prawn::Document.new(page_size: [375, 600]) do |pdf|
      pdf.text "Event Ticket", size: 20, style: :bold, align: :center
      pdf.move_down 10


      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width / 2) do
        pdf.text "Event: #{@event.title}", size: 12, style: :bold
        pdf.text "Date: #{@event.start_date.strftime('%B %d, %Y')}", size: 10
        pdf.text "Location: #{@event.location}", size: 10
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.width / 2, pdf.cursor], width: pdf.bounds.width / 2) do

        pdf.text "Booked By: #{@user.name}", size: 10
        pdf.text "Total Quantity: #{@registration.quantity}", size: 10
        # pdf.text "Sequence:  of #{@registration.quantity}", size: 10
        pdf.stroke_bounds
      end
      pdf.move_down 10

      qr_code = generate_qr_code
      pdf.image StringIO.new(qr_code.to_s), width: 250, height: 250, position: :center
      pdf.move_down 10

      pdf.text "Thank you for registering!", size: 10, align: :center
    end.render

    attach_pdf_to_registration(pdf_content)
  end

  private

  def generate_qr_code
    require 'securerandom'
    @qr_code_uuid = SecureRandom.uuid
    # qr_code_content = "Event: #{@event.title}, Date: #{@event.start_date}, Attendee: #{@user.name}, Quantity: #{@registration.quantity}"
    qr_code_content = {
      barcode_uuid: @qr_code_uuid,
      event: @event.title,
      event_date: @event.start_date,
      attendee: @user.name,
      purchase_date: @registration.created_at,
      quantity: @registration.quantity
    }.to_json
    qrcode = RQRCode::QRCode.new(qr_code_content)
    qrcode.as_png(size: 250)
  end

  def attach_pdf_to_registration(pdf_content)
    @registration.ticket_pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "ticket_#{@qr_code_uuid}.pdf",
      content_type: 'application/pdf'
    )
    # @registration.ticket.build()
    tikcet = @registration.build_ticket(
      ticket_type: @ticket_type,
      qr_code: @qr_code_uuid
    )
    tikcet.save!

  end

end