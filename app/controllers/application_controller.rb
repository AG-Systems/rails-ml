class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def page_not_found
      respond_to do |format|
        format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
        format.all  { render nothing: true, status: 404 }
      end
    end  
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) 
    devise_parameter_sanitizer.permit(:sign_in) 
    devise_parameter_sanitizer.permit(:account_update) 
  end
  
end
