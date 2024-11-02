class CheckIn < ApplicationRecord
  belongs_to :ticket
  belongs_to :event
  belongs_to :checked_by, polymorphic: true
end
