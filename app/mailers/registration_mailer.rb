class RegistrationMailer < ApplicationMailer
  def confirmation(registration)
    @event_registration = registration
    @event = registration.ticket_type.event
    @user = registration.user
    attachments['tickets.pdf'] = TicketPdfGenerator.new(registration).generate
    mail(
      to: @user.email,
      subject: "Your tickets for #{@event.title}"
    )
  end
end