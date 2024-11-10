class BaseCommand
  include ActiveModel::Validations

  def initialize(**args)
    @args = args
  end
  class << self
    def call(**args)
      new(**args).call
    end
  end

  def call
    return failure(:invalid, errors) unless valid?
    begin
      ActiveRecord::Base.transaction do
        execute
      end
    rescue ActiveRecord::RecordInvalid => e
      failure(:invalid_record, e.record.errors)
    rescue ActiveRecord::RecordNotFound => e
      failure(:not_found, e.message)
    rescue StandardError => e
      Rails.logger.error("Command failed: #{e.message}\n#{e.backtrace.join("\n")}")
      failure(:error, "An unexpected error occurred")
    end
  end

  private

  def execute
    raise NotImplementedError
  end

  def success(data = nil, status: :ok)
    Result.new(success: true, data: data, status: status)
  end

  def failure(error_type, errors, status: :unprocessable_entity)
    Result.new(success: false, errors: errors, status: status)
  end
end
