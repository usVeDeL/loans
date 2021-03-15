class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    add_flash_types :success, :danger, :warning
    before_action :configure_permitted_parameters, if: :devise_controller?

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :last_name, :mail, :password, :password_confirmation, :role_id, :active])
    end
    
    def after_sign_in_path_for(resource)
        index_path
    end
end
