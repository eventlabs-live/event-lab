class EventPublishedJob < ApplicationJob
  queue_as :default
  def perform(event)
    # Send notifications
    EventMailer.published_notification(event).deliver_now
    # Social media integrations
    SocialMediaService.post_event(event) if event.social_media_enabled?
    # Update search indices
    event.reindex
  end
end