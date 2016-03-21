class TransactionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin]
  before_filter :save_login_state, :only => [:login, :login_attempt]


  before_action :only => [:new, :create]

  def new
    gon.client_token = generate_new_client_token
  end

  def create
    @result = Braintree::Transaction.sale(
              amount: 5, #MONEY HERE FROM ITEM
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      redirect_to root_url, notice: "Congraulations! Your transaction has been successfully!"
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_new_client_token
      render :new
    end
  end



  private
  def generate_new_client_token
    Braintree::ClientToken.generate
  end
end
