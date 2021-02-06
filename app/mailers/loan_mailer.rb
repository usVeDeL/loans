class LoanMailer < ApplicationMailer
  default from: 'ferb@losinfiltrados.com'

  def new_loan(loan)
    @loan = loan
    mail(to: 'delvefin@gmail.com, huarci@gmail.com', subject: "Se ha creado un grupo nuevo")
  end
end