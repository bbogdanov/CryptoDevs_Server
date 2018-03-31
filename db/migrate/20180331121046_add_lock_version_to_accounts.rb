class AddLockVersionToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :lock_version, :integer, null: false, default: 0
  end
end
