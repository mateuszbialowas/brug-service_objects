# frozen_string_literal: true

class UserController < ApplicationController
  def create
    user_create = Users::Create.call(user_params:, shop_params:)

    if user_create.success?
      flash.now[:notice] = "User created. Happy now? I hope so."
      render 'user/create', locals: {
        user: user_create.result[:user],
        shop: user_create.result[:shop]
      }
    else
      flash.now[:error] = result.error
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
