class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :pending_withdrawals

  def self.create_btc_account(user)
    acc = Account.new
    acc.currency_code = 'BTC'
    acc.user = user
    acc.save!
  end

  def self.create_eth_account(user)
    acc = Account.new
    acc.currency_code = 'ETH'
    acc.user = user
    acc.save!
  end

  def deposit(amount)
    ActiveRecord::Base.transaction do
      tr = Transaction.new
      tr.transaction_code = 'USRDEP'
      tr.amount = amount
      tr.account = self
      tr.save!
      self.balance += amount
      self.save!
    end
  end

  def withdraw(amount)
    raise ArgumentError, 'Insufficient funds' if balance < amount
    
    ActiveRecord::Base.transaction do
      tr = Transaction.new
      tr.transaction_code = 'USRWDR'
      tr.amount = -amount
      tr.account = self
      tr.save!
      self.balance -= amount
      self.save!
    end
  end

  def balance
    self.transactions.sum(:amount)
  end

  def transfer_to(account_id, amount)
    raise ArgumentError, 'Insufficient funds' if balance < amount

    ActiveRecord::Base.transaction do
      self.withdraw(amount)
      Account.find(account_id).deposit(amount)
    end
  end
end