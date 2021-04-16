class RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication
  # before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]
  
  def new
    super
  end
end