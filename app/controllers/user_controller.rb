# frozen_string_literal: true

class UserController < ApplicationController
  def create
    # TODO: write your code here. You can inspire by this code: https://github.com/mateuszbialowas/brug-service_objects/pull/1/files
  end

  private

  def user_params
    params.permit(:name, :email)
  end

  def shop_params
    params.permit(:industry_id, :name)
  end
end
