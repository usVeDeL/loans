class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :send_contact_email]
  skip_before_action :verify_authenticity_token

  # skip_before_action :verify_authenticity_token  
  # protect_from_forgery :except => [:send_contact_email]


  def home
    redirect_to index_path if signed_in?
  end

  def index
  end

  def send_contact_email
    if StaticPagesMailer.send_contact_email(
      name: params[:name],
      email: params[:email],
      message: params[:message]
    ).deliver
      flash[:success] = 'Correo enviado exitosamente'
      redirect_to root_path
    else
      flash[:danger] = 'Hubo un error al enviar el correo'
      render "static_pages/home"
    end 
  end
end
