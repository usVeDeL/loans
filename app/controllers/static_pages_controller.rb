class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :send_contact_email]
  skip_before_action :verify_authenticity_token

  def home
    redirect_to index_path if signed_in?
  end

  def index
  end

  def send_contact_email
    unless params[:name].present?
      flash[:danger] = 'El nombre no puede ir vacio'

      return render 'static_pages/home'
    end
    
    unless params[:email].present?

      flash[:danger] = 'El correo electrónico es inválido'

      return render 'static_pages/home'
    end
    
    unless params[:email].match?(URI::MailTo::EMAIL_REGEXP)
      flash[:danger] = 'El correo electrónico es inválido'

      return render 'static_pages/home'
    end

    if StaticPagesMailer.send_contact_email(
      name: params[:name],
      email: params[:email],
      message: params[:message]
    ).deliver

      flash[:success] = 'Correo enviado exitosamente'

      redirect_to root_path
    else
      flash[:danger] = error_text

      render 'static_pages/home'
    end 
  end
end
