class IndexController < ApplicationController
  skip_before_action :authenticate_user!, only: [:send_contact_email]

  def new
  end

  def edit
  end

  def send_contact_email
    IndexMailer.send_contact_email(
      name: params[:name],
      email: params[:email],
      message: params[:message]
    ).deliver
    
    flash[:success] = 'Correo enviado exitosamente'
    redirect_to root_path
  end
end
