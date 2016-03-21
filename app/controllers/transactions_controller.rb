class TransactionsController < ApplicationController
  def new
    gon.client_token = generate_new_client_token
  end

  def create
    @result = Braintree::Transaction.sale(
              amount: 5, #MONEY HERE FROM ITEM
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      flash[:notice] = "Congraulations! Your transaction has been successfully!"
      redirect_to(:action => 'login', :controller => 'sessions')
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
