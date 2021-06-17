class InterestsWeeklyMailer < ApplicationMailer
  default from: 'sistemas@vedel.com.mx'

  def send_report(report)
    attachments["reporte de intereses #{1.week.ago.strftime('%F')}-#{DateTime.now.strftime('%F')}.csv"] = {mime_type: 'text/csv', content: report}
    mail(to: 'sistemas@delve.com.mx', subject: "reporte de intereses #{1.week.ago.strftime('%F')}-#{DateTime.now.strftime('%F')}")
  end
end