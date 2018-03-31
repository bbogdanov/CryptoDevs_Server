class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_code, limit: 10
      t.decimal :amount, precision: 30, scale: 18, null: false
    end

    add_reference :transactions, :account, foreign_key: true
  end
end
