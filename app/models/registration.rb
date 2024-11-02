class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: { registered: 0, attending: 1, cancelled: 2 }
end
