class SubscribersController < ApplicationController
    before_filter :authenticate_user!
    
    def new
    end
    def create
    end
    def show
        token = params[:stripeToken]
        
        customer = Stripe::Customer.create(
            card: token,
            plan: 0000,
            #email: current_user.email
        
            )
            current_user.subscribed = true
            current_user.stripeid = customer.id
            current_user.save
            
             redirect_to root_path, notice: "Your subscription was set up successfully!"
    end
    def update
    
        token = params[:stripeToken]
        
        customer = Stripe::Customer.create(
            card: token,
            plan: 0000,
            #email: current_sign_in.email
        
            )
            current_user.subscribed = true
            current_user.stripeid = customer.id
            current_user.save
            
             redirect_to root_path, notice: "Your subscription was set up successfully!"
    end
    
end
