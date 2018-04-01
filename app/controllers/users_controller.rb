class UsersController < ApplicationController
  # Use Knock to make sure the current_user is authenticated before completing request.
  before_action :authenticate_user,  only: [:index, :current, :update, :balance]
  before_action :authorize_as_admin, only: [:destroy]
  before_action :authorize,          only: [:update]

  # Should work if the current_user is authenticated.
  def index
    render json: {status: 200, msg: 'Logged-in'}
  end
  
  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    current_user.update!(last_login: Time.now)
    render json: current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: {status: 200, msg: 'User was created.'}
    end
  end
  
  # Method to update a specific user. User will need to be authorized.
  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { status: 200, msg: 'User details have been updated.' }
    end
  end
  
  # Method to delete a user, this method is only for admin accounts.
  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { status: 200, msg: 'User has been deleted.' }
    end
  end

  def balance
    accounts = Account.where(user_id: current_user.id)
    response = accounts.map { |acc| { acc.currency_code => acc.balance } }
    render json: response
  end

  def transfer
    # Exctract this into a sidekiq worker
    user = User.find_by_email(params[:email])

    if user.nil?
      render json: { status: 404, msg: "User not found!"}
    else
      currency_code = params[:currency_code].upcase
      account_sender = Account.where(user_id: current_user.id).where(currency_code: currency_code.upcase).first
      account_recipient = Account.where(user_id: user.id).where(currency_code: currency_code.upcase).first
      account_sender.transfer_to(account_recipient.id, BigDecimal.new(params[:amount]))
      render json: { status: 200, currency_code.upcase => account_sender.balance }
    end
  end

  private
  
  # Setting up strict parameters for when we add account creation.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  # Adding a method to check if current_user can update itself. 
  # This uses our UserModel method.
  def authorize
    return_unauthorized unless current_user && current_user.can_modify_user?(params[:id])
  end
end
