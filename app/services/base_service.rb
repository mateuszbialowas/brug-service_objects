# frozen_string_literal: true

require 'dry/monads'

module BaseService
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  module ClassMethods
    def call(**args)
      new(**args).tap(&:call)
    end
  end
  def result
    @_result ||= {}
  end

  def errors
    @_errors ||= []
  end

  def success?
    errors.blank?
  end

  def failure?
    !success?
  end

  protected

  def add_error(error)
    errors.push(error)
  end

  def add_result(**hash)
    result.merge!(**hash)
  end
end
