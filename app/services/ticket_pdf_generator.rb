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
    pdf_content = Prawn::Document.new do |pdf|
      pdf.text "Event Ticket", size: 30, style: :bold, align: :center
      pdf.move_down 20

      pdf.text "Event: #{@event.title}", size: 20, style: :bold
      pdf.text "Date: #{@event.start_date.strftime('%B %d, %Y')}", size: 16
      pdf.text "Location: #{@event.location}", size: 16
      pdf.move_down 20

      pdf.text "Attendee: #{@user.name}", size: 16
      pdf.text "Quantity: #{@registration.quantity}", size: 16
      pdf.move_down 20

      qr_code = generate_qr_code
      pdf.image StringIO.new(qr_code.to_s), width: 100, height: 100, position: :center
      pdf.move_down 20

      pdf.text "Thank you for registering!", size: 16, align: :center
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
    qrcode.as_png(size: 200)
  end

  def attach_pdf_to_registration(pdf_content)
    @registration.ticket_pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "ticket_#{@registration.id}.pdf",
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