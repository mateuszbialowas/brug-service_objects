# frozen_string_literal: true

class UserController < ApplicationController
  def create
    result = Users::Create.new(user_params:, shop_params:).call
    if result.success?
      flash.now[:notice] = result.success[:message]
      render 'user/create', locals: { user: result.success[:user], shop: result.success[:shop] }
    else
      flash.now[:error] = result.failure
      render 'user/new'
    end
  end

  private

  def user_params
    params.permit(:name, :email)
  end

  def shop_params
    params.permit(:industry_id, :name)
  end
end
