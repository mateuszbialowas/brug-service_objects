# frozen_string_literal: true

FactoryBot.define do
  factory :industry do
    name { FFaker::Food.fruit }
  end
end
