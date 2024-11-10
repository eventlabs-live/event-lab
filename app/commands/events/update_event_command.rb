module Events
  class UpdateEventCommand < BaseCommand
    attr_reader :params, :organizer

    def initialize(params:, organizer:)
      @params = params
      @organizer = organizer
    end

    private

    def execute
      event = find_event
      if event.update(@params)
        # do other stuff
        success(event, status: :updated)
      else
        failure(:save_failed, event.errors)
      end
    end

    def find_event
      Event.find(@params[:id])
    end
  end
end