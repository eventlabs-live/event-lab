class Event < ApplicationRecord
  include AASM
  after_initialize :set_defaults
  belongs_to :organizer, class_name: 'User'
  has_many :ticket_types, dependent: :destroy
  accepts_nested_attributes_for :ticket_types
  has_many :tickets, through: :ticket_types
  has_many :event_registrations
  has_many :attendees, through: :event_registrations
  has_one_attached :cover_image
  has_many_attached :gallery_images
  validates :title, :start_date, :end_date, :location, presence: true
  validate :end_date_after_start_date

  scope :featured_event, -> { where(featured: true).first }
  scope :upcoming, -> { where('start_date >= ?', Date.current).order(start_date: :asc) }

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
    errors.add(:end_date, "must be after the start date") if end_date < start_date
  end

  def set_defaults
    self.start_date ||= Date.today
    self.end_date ||= Date.today
    self.ticket_types << TicketType.default(self) if self.ticket_types.empty?
  end
end
