class LoanMailer < ApplicationMailer
  default from: 'sistemas@vedel.com.mx'

  def new_loan(loan)
    @loan = loan
    mail(to: 'delvefin@gmail.com', subject: "Se ha creado un grupo nuevo")
  end
end