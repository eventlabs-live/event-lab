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
  end
end
