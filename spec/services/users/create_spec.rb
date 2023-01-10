# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Users::Create, type: :service do
  subject(:service) { described_class.call(user_params:, shop_params:) }
  let(:industry) { create(:industry) }
  let(:industry_id) { industry.id }
  let(:user_params) { { name: 'John', email: 'john2n@gmail.com' } }
  let(:shop_params) { { industry_id:, name: 'John Shop' } }

  context 'when shop_params are invalid' do
    let(:industry_id) { 0 }

    it 'returns failure' do
      expect { service }.to not_change { User.count }.and not_change { Shop.count }
      expect(service.errors).to eq([ { industry_id: ['Industry not found'] }])
    end
  end

  context 'when user params are invalid' do
    let(:user_params) { { name: nil, email: nil } }

    it 'returns failure' do
      expect { service }.to not_change { User.count }.and not_change { Shop.count }
      expect(service.errors).to eq([{ email: ['must be filled'] , name: ['must be filled']}])
    end
  end

  context 'when error creating shop' do
    before do
      allow_any_instance_of(Shop).to receive(:save).and_return(false)
      allow_any_instance_of(Shop).to receive(:errors).and_return(double(full_messages: ['Shop error']))
    end

    it 'returns failure' do
      expect { service }.to not_change { User.count }.and not_change { Shop.count }
      expect(service.errors).to eq([{shop: 'Shop error'}])
    end
  end

  context 'when error creating user' do

    before do
      allow_any_instance_of(User).to receive(:save).and_raise(ActiveRecord::ConnectionTimeoutError )
    end

    it 'returns failure' do
      expect { service }.to not_change { User.count }.and not_change { Shop.count }
      expect(service.errors).to eq(["ActiveRecord::ConnectionTimeoutError"])
    end
  end

  context 'when params are valid and success creating user and shop' do
    it 'returns success' do
      expect { service }.to change { User.count }.by(1).and change { Shop.count }.by(1)
      expect(service.result[:user]).to be_a(User)
      expect(service.result[:shop]).to be_a(Shop)
    end
    it 'sends registration email' do
      expect { service }.to have_enqueued_mail(RegistrationMailer, :welcome_email)
    end
  end
end
