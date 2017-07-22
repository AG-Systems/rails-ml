class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def page_not_found
      respond_to do |format|
        format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
        format.all  { render nothing: true, status: 404 } # Need to delete this soon
      end 
    end  
  
  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end
  
  protected
 
  
end
