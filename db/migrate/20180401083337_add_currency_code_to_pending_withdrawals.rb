class AddCurrencyCodeToPendingWithdrawals < ActiveRecord::Migration[5.1]
  def change
    add_column :pending_withdrawals, :currency_code, :string
  end
end
