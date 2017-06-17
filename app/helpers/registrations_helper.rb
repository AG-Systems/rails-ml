module RegistrationsHelper
   def account_params
    params.require(:user).permit(:email, :password, :current_password, :password_confirmation)
  end
end
