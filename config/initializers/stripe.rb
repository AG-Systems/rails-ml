 Rails.configuration.stripe = { 
  :publishable_key => 'pk_live_gvl6xe7n06BRsxmzpVWrwcpq', 
  :secret_key => 'sk_live_hMxsXLpXQt36H3tYV6OLmJsu'
} 

Stripe.api_key = Rails.configuration.stripe[:secret_key]