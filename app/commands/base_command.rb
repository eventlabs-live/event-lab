class BaseCommand
  include ActiveModel::Validations

  class << self
    def call(*args)
      new(*args).call
    end
  end

  def call
    return false unless valid?
    begin
      ActiveRecord::Base.transaction do
        execute
      end
      true
    rescue => e
      errors.add(:base, e.message)
      false
    end
  end
end
