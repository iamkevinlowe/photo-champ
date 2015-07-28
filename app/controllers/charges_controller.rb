class ChargesController < ApplicationController 

  def create
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken],
      plan: 'PhotoChampPremium'
    )

    current_user.update_attributes!(role: 'premium', stripe_customer_id: customer.id)

    flash[:notice] = "Thanks for upgrading to a premium account!"
    redirect_to current_user

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to :back
  end

  def cancel_subscription
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    if customer.subscriptions.first.delete
      current_user.update_attributes!(role: 'standard')
      flash[:notice] = "You have downgraded to a free standard account."
      redirect_to current_user
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to :back
    end
  end
end