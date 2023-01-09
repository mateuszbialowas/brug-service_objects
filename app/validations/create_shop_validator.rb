# frozen_string_literal: true

class CreateShopValidator < Dry::Validation::Contract
  params do
    required(:industry_id).filled(:integer)
    required(:name).filled(:string)
  end

  rule(:industry_id) do
    key.failure('Industry not found') unless Industry.exists?(value)
  end
end
