class CreateEventCommand < BaseCommand
  attr_reader :params, :organizer

  def initialize(params:, organizer:)
    @params = params
    @organizer = organizer
  end

  private

  def execute
    event = Event.new(@params)
    event.organizer = @organizer
    event.save!
      # return event
      # @params[:ticket_types].flatten.each do |ticket_type_params|
      #   event.ticket_types.create!(ticket_type_params)
      # end
      # EventCreatedJob.perform_later(event)
    # else
    #   errors.full_messages.each { |message| errors.add(:base, message) }
    # end
  end
end
