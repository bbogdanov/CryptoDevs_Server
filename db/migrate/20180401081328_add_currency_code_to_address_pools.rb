class AddCurrencyCodeToAddressPools < ActiveRecord::Migration[5.1]
  def change
    add_column :address_pools, :currency_code, :string
  end
end
