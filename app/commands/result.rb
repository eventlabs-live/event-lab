class Result
  attr_reader :data, :errors, :status

  def initialize(success:, data: nil, errors: nil, status: nil)
    @success = success
    @data = data
    @errors = errors
    @status = status
  end

  def success?
    @success
  end

  def failure?
    !success?
  end

  def error_messages
    return [] unless errors

    case errors
    when ActiveModel::Errors
      errors.full_messages
    when Array
      errors
    when String
      [errors]
    else
      errors.to_s.split(", ")
    end
  end
end

