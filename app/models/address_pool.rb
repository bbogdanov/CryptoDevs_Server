class AddressPool < ApplicationRecord
  def self.first_free(currency_code)
    address = AddressPool.where(status: 'free').where(currency_code: currency_code).first
    address.status = 'taken'
    address.save!
    address
  end
end
