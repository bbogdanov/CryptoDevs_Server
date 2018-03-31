class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :currency_code, null: false
      t.decimal :balance, precision: 30, scale: 18, default: 0, null: false
    end

    add_reference :accounts, :user, foreign_key: true
  end
end
