# frozen_string_literal: true
class BaseService
  attr_reader :result, :error

  def self.call(**args)
    new(**args).tap { |s| catch(:service_error) { s.call } }
  end

  def fail!(error = :error)
    @error = error
    throw :service_error
  end

  def success?
    error.nil?
  end

  def failure?
    !success?
  end
end
