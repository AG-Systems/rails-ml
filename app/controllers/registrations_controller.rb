class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: [:create]
    #include RegistrationsHelper
    def new
        super
        
    end
  
    protected
    def after_sign_up_path_for(resource) 
        #'/subscribers/new'
        '/'
    end
    private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        respond_with_navigational(resource) { render :new }
      end 
    end
end
