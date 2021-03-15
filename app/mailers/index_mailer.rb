class IndexMailer < ApplicationMailer
  default from: 'ferb@losinfiltrados.com'

  def send_contact_email(name: nil, email: nil, message: nil)
    @name = name
    @email = email 
    @message = message

    mail(to: 'sistemas@vedel.com.mx, sauldelrazo@vedel.com.mx', subject: 'Tienes un nuevo mensaje desde la pagina vedel')
  end
end
