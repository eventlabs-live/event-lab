# Registration specific commands
module Registrations
  class CreateRegistrationCommand < BaseCommand

    # attr_reader :event_id, :ticket_type_id, :quantity

    def initialize(params:, user:)
      @params = params
      @user = user
    end

    # validates :event_id, presence: true
    # validates :ticket_type_id, presence: true
    # validates :quantity, presence: true, numericality: { greater_than: 0 }
    # validate :event_exists
    # validate :ticket_type_exists
    # validate :tickets_available
    # validate :not_already_registered

    private

    def execute
      registration = build_registration

      if registration.save
        process_successful_registration(registration)
        success(registration, status: :created)
      else
        failure(:registration_failed, registration.errors)
      end
    end

    def build_registration

      event.event_registrations.build(@params).tap do |registration|
        registration.user = @user
        #   registration.ticket_type: ticket_type,
        #   quantity: @params[:quantity],
        #   registration.attendee_details: params[:attendee_details]
      end
    end

    def event
      @event ||= Event.find(@params[:event_id])
    end

    def ticket_type
      @ticket_type ||= event.ticket_types.find(@params[:ticket_type_id])
    end

    def event_exists
      event
    rescue ActiveRecord::RecordNotFound
      errors.add(:event_id, "event not found")
    end

    def ticket_type_exists
      ticket_type
    rescue ActiveRecord::RecordNotFound
      errors.add(:ticket_type_id, "ticket type not found")
    end

    def tickets_available
      return unless ticket_type && params[:quantity]
      return if ticket_type.available_quantity >= params[:quantity]

      errors.add(:quantity, "exceeds available tickets")
    end

    def not_already_registered
      return unless event && user
      return unless event.registrations.exists?(user: user)

      errors.add(:base, "already registered for this event")
    end

    def process_successful_registration(registration)
      create_payment(registration)
      schedule_confirmation_email(registration)
      notify_organizer(registration)
    end

    def create_payment(registration)
      # Commands::Payments::CreatePayment.call(
      #   user: user,
      #   registration: registration,
      #   amount: registration.total_amount,
      #   payment_method: params[:payment_method]
      # )
    end

    def schedule_confirmation_email(registration)
      # RegistrationMailer.confirmation(registration).deliver_later
    end

    def notify_organizer(registration)
      # NewRegistrationNotification.deliver_to_organizer(registration)
    end
  end
end
