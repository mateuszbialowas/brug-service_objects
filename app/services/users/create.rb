# frozen_string_literal: true
module Users
  class Create < BaseService
    def initialize(user_params:, shop_params:)
      @user_params = user_params
      @shop_params = shop_params
    end

    def call
      user_validation = validate_user_params
      return user_validation if user_validation.failure?

      shop_validation = validate_shop_params
      return shop_validation if shop_validation.failure?
      begin
        ActiveRecord::Base.transaction do
          shop = create_shop(@shop_params)
          raise StandardError.new shop.failure if shop.failure?

          user = create_user(shop.success, @user_params)
          raise StandardError.new user.failure if user.failure?

          RegistrationMailer.with(user: user.success).welcome_email.deliver_later
          Success({ user: user.success, shop: shop.success, message: 'User registered successfully' })
        end
      rescue StandardError => exception
        return Failure(exception.message)
      end

    end

    private

    def validate_user_params
      result = CreateUserValidator.new.call(@user_params)
      result.success? ? Success(result) : Failure(result.errors.to_h)
    end

    def validate_shop_params
      result = CreateShopValidator.new.call(@shop_params)
      result.success? ? Success(result) : Failure(result.errors.to_h)
    end

    def create_shop(shop_params)
      shop = Shop.new(industry_id: shop_params[:industry_id], name: shop_params[:name])
      shop.save ? Success(shop) : Failure(shop.errors.full_messages.join(', '))
    end

    def create_user(shop, user_params)
      user = User.new(shop:, name: user_params[:name], email: user_params[:email])
      user.save ? Success(user) : Failure(user.errors.full_messages.join(', '))
    end
  end
end
