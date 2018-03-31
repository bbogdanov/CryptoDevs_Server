class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  def deposit(amount)
    tr = Transaction.new
    tr.transaction_code = 'USRDEP'
    tr.amount = amount
    tr.account = self
    tr.save!
  end

  def withdraw(amount)
    raise ArgumentError, 'Insufficient funds' if balance < amount
    
    tr = Transaction.new
    tr.transaction_code = 'USRWDR'
    tr.amount = -amount
    tr.account = self
    tr.save!
  end

  def balance
    self.transactions.sum(:amount)
  end

  def transfer_to(account_id, amount)
    raise ArgumentError, 'Insufficient funds' if balance < amount

    ActiveRecord::Base.transaction do
      self.withdraw(amount)
      Account.find(account_id).deposit(amount)
      self.touch
    end
  end
end