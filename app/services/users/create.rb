# frozen_string_literal: true
module Users
  class Create < BaseService
    def initialize(user_params:, shop_params:)
      @user_params = user_params
      @shop_params = shop_params
    end

    def call
      fail! :shop_invalid if CreateShopValidator.new.call(@shop_params).failure?
      fail! :user_invalid if CreateUserValidator.new.call(@user_params).failure?

      ActiveRecord::Base.transaction do
        @shop = Shop.create!(@shop_params)
        @user = User.create!(@user_params.merge(shop: @shop))
      end

      RegistrationMailer.with(user: @user).welcome_email.deliver_later
    rescue => e
      fail! e.to_sym
    ensure
      @result = {shop: @shop, user: @user}
    end
  end
end
