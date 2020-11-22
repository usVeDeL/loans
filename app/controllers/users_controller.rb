class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.reset_password_token = 'temp'
    
    if @user.update(user_params)
      flash[:success] = "Cambios guardados correctamente"
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.delete
      flash[:success] = 'Cambios guardados correctamente'
      redirect_to users_path
    else
      flash[:danger] = 'Error... algo salio mal'
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :last_name, :mail, :active, :role_id, :password, :password_confirmation)
  end
end
