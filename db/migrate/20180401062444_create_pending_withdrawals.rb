class CreatePendingWithdrawals < ActiveRecord::Migration[5.1]
  def change
    create_table :pending_withdrawals do |t|
      t.string :address
      t.decimal :amount
      t.string :status

      t.timestamps
    end

    add_reference :pending_withdrawals, :account, foreign_key: true
  end
end
