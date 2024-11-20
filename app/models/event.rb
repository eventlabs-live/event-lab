class Event < ApplicationRecord
  include AASM
  after_initialize :set_defaults
  belongs_to :organizer, class_name: 'User'
  has_many :ticket_types, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :ticket_types
  # has_many :tickets, through: :ticket_types
  has_many :tickets, through: :event_registrations
  has_many :event_registrations
  has_many :attendees, through: :event_registrations
  has_one_attached :cover_image
  has_many_attached :gallery_images
  belongs_to :category, optional: true
  belongs_to :subcategory, optional: true
  # validates :title, :start_date, :end_date, :location, presence: true
  # validate :end_date_after_start_date

  scope :featured_events, -> { where(featured: true, status: Event.statuses[:published]) }

  scope :upcoming, -> { where('start_date >= ? AND status = ?', Date.current, Event.statuses[:published]).order(start_date: :asc) }

  #ToDo define logic for trending events, e.g weighted on tickets sold, followed, views
  scope :trending, -> { self.upcoming.order(clicks: :desc) }

  #ToDo define logic for most popular events, e.g tickets sold
  scope :most_popular, -> { self.upcoming.order(clicks: :desc).limit(10) }

  #ToDo define logic for 'more' events, e.g upcoming events
  scope :more_events, -> { where('start_date >= ? AND status = ?', Date.current, Event.statuses[:published]).order(start_date: :asc) }

  enum status: {
    draft: 1,
    published: 2,
    cancelled: 3,
    completed: 4
  }

  aasm column: :status do
    state :draft, initial: true
    state :published
    state :cancelled
    state :completed
    event :publish do
      transitions from: :draft, to: :published
      after do
        EventPublishedJob.perform_later(self)
      end
    end
    event :cancel do
      transitions from: [:draft, :published], to: :cancelled
      after do
        process_cancellation
      end
    end
  end

  def process_cancellation
    # TicketRefundJob.perform_later(self)
    # EventCancellationNotifierJob.perform_later(self)
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "must be after the start date") if end_date < start_date
  end

  def set_defaults
    self.start_date ||= Date.today
    self.end_date ||= Date.today
    self.ticket_types << TicketType.default(self) if self.ticket_types.empty?
    # self.status ||= :draft
    self.current_step ||= 1
  end
end
