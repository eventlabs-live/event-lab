module Events
  class CreateEventCommand < BaseCommand
    attr_reader :params, :organizer, :event

    def initialize(params:, organizer:)
      @params = params
      @organizer = organizer
    end

    private

    def execute
      @event = Event.new(@params)
      @event.organizer = @organizer
      if @event.save
        # schedule_related_jobs(event)
        # notify_stakeholders(event)
        success(@event, status: :created)
      else
        failure(:save_failed, @event.errors)
      end
    end
  end
end
