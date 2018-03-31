class User < ApplicationRecord
  has_secure_password
  has_many :accounts

  validates_length_of       :password, maximum: 72, minimum: 8, allow_nil: true, allow_blank: false
  validates_confirmation_of :password, allow_nil: true, allow_blank: false

  before_validation { 
    (self.email = self.email.to_s.downcase) 
  }

  validates_presence_of     :email
  validates_uniqueness_of   :email

  after_create :create_account

  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  def is_admin?
    role == 'admin'
  end

  private

  def create_account
    ActiveRecord::Base.transaction do
      Account.create_btc_account(self)
      Account.create_eth_account(self)
    end
  end
end
