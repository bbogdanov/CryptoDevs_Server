class CreateAddressPools < ActiveRecord::Migration[5.1]
  def change
    create_table :address_pools do |t|
      t.string :address
      t.decimal :amount, precision: 30, scale: 18, default: 0, null: false
      t.string :transaction_hash
      t.string :status

      t.timestamps
    end
  end
end
