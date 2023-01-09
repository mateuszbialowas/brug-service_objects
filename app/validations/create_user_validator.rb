# frozen_string_literal: true

class CreateUserValidator < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:email).filled(:string)
  end

  rule(:email) do
    key.failure('has invalid format') unless EmailAddress.valid?(value)
    key.failure('is not unique') if User.exists?(email: value)
  end
end
