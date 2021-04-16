class ApplicationController < ActionController::Base
  ACTIONS_CATALOG = {
    'new' => 'create',
    'show' => 'view',
    'index' => 'view',
    'edit' => 'edit',
    'destroy' => 'delete',
    'create' => 'create',
    'update' => 'edit'
  }

  before_action :authenticate_user!
  add_flash_types :success, :danger, :warning
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :last_name, :mail, :password, :password_confirmation, :role_id, :active])
  end
  
  def after_sign_in_path_for(resource)
    index_path
  end

  def success_text
    'Cambios guardados correctamente'
  end

  def error_text
    'Error... algo salio mal'
  end

  def create_log(text)
    Log.create!(
      user_id: current_user.id,
      description: text
    )
  end

  def is_view_permitted?
    begin
      controller = controller_name == 'registrations' ? 'users' : controller_name 
    
      return true if current_user.send("role_can_#{ACTIONS_CATALOG[action_name]}_#{controller}")
      
      flash[:danger] = 'No tienes permisos para realizar esta acción'
      redirect_to root_path 
    rescue
      flash[:danger] = 'No tienes permisos para realizar esta acción'
      redirect_to root_path 
    end
  end
end
