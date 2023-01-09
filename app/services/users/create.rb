# frozen_string_literal: true
module Users
  class Create < BaseService
    def initialize(user_params:, shop_params:)
      @user_params = user_params
      @shop_params = shop_params
    end

    def call
      validated_user_params = yield validate_user_params
      validated_shop_params = yield validate_shop_params
      ActiveRecord::Base.transaction do
        shop = yield create_shop(validated_shop_params)
        user = yield create_user(shop, validated_user_params)

        RegistrationMailer.with(user:).welcome_email.deliver_later

        Success({ user:, shop:, message: 'User registered successfully' })
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

    def create_shop(validated_shop_params)
      shop = Shop.new(industry_id: validated_shop_params[:industry_id], name: validated_shop_params[:name])
      shop.save ? Success(shop) : Failure(shop.errors.full_messages.join(', '))
    end

    def create_user(shop, validated_user_params)
      user = User.new(shop:, name: validated_user_params[:name], email: validated_user_params[:email])
      user.save ? Success(user) : Failure(user.errors.full_messages.join(', '))
    end
  end
end
