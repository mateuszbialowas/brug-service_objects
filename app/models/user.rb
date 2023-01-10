class User < ApplicationRecord
  belongs_to :shop
  validates :name, presence: true
end
