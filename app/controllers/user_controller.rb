# frozen_string_literal: true

class UserController < ApplicationController
  def create
    Users::Create.new(params).call
  end
end
