# frozen_string_literal: true

require 'dry/monads'

class BaseService
  include Dry::Monads[:do, :result]
end
