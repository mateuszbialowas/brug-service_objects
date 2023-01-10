# frozen_string_literal: true
module Users
  class Create
    include BaseService
    def initialize(user_params:, shop_params:)
      @user_params = user_params
      @shop_params = shop_params
    end

    def call
      validate_shop_params
      validate_user_params
      if errors.empty?
        begin
          ActiveRecord::Base.transaction do
            create_shop(@shop_params)
            create_user(result[:shop], @user_params) if result[:shop].present?

            RegistrationMailer.with(user: result[:user]).welcome_email.deliver_later if result[:user].present?
          end
        rescue => e
          add_error(e.to_s)
        end
      end
    end

    private

    def validate_user_params
      result = CreateUserValidator.new.call(@user_params)
      add_error(result.errors.to_h) if result.failure?
    end

    def validate_shop_params
      result = CreateShopValidator.new.call(@shop_params)
      add_error(result.errors.to_h) if result.failure?
    end

    def create_shop(validated_shop_params)
      shop = Shop.new(industry_id: validated_shop_params[:industry_id], name: validated_shop_params[:name])
      if shop.save
        add_result(shop: shop)
      else
        add_error({shop: shop.errors.full_messages.join(', ')})
      end
    end

    def create_user(shop, validated_user_params)
      user = User.new(shop:, name: validated_user_params[:name], email: validated_user_params[:email])
      if user.save
        add_result(user: user)
      else
        add_error({user: user.errors.full_messages.join(', ')})
      end
    end

  end
end
