# frozen_string_literal: true
class RegistrationService
  def self.process(ticket_type:, user:, quantity:, payment_method:)
    Registration.transaction do
      registration = Registration.create!(
        user: user,
        ticket_type: ticket_type,
        quantity: quantity
      )
      payment = PaymentService.process(
        amount: ticket_type.current_price * quantity,
        payment_method: payment_method,
        registration: registration
      )
      if payment.successful?
        quantity.times do
          Ticket.create!(
            registration: registration,
            ticket_type: ticket_type,
            qr_code: generate_qr_code
          )
        end
        RegistrationMailer.confirmation(registration).deliver_later
        true
      else
        raise ActiveRecord::Rollback
        false
      end
    end
  end
  private
  def self.generate_qr_code
    SecureRandom.uuid
  end
end
