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
    create_log("Se ha actualizado el usuario: #{@user.name}.")

    if @user.update(user_params)
      flash[:success] = success_text

      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    create_log("Se ha eliminado el usuario: #{user.name}.")

    if user.delete
      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :name,
      :last_name,
      :mail,
      :active,
      :role_id,
      :password,
      :password_confirmation
    )
  end
end
