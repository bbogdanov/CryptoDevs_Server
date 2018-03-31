class AddAddressToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :address, :string
  end
end
