# frozen_string_literal: true
module Users
  class Create < BaseService
    def initialize(user_params:, shop_params:)
      @user_params = user_params
      @shop_params = shop_params
    end

    def call
      # TODO: write your code here. You can inspire by this code: https://github.com/mateuszbialowas/brug-service_objects/pull/1/files
    end
  end
end
