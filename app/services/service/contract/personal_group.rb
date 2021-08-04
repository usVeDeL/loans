module Service
  module Contract
    class PersonalGroup
      include ActionView::Helpers::NumberHelper

      MONTHS = {
        'January' => 'Enero',
        'February' => 'Febrero',
        'March' => 'Marzo',
        'April' => 'Abril',
        'May' => 'Mayo',
        'June' => 'Junio',
        'July' => 'Julio',
        'August' => 'Agosto',
        'September' => 'Septiembre',
        'October' => 'Octubre',
        'November' => 'Noviembre',
        'December' => 'Diciembre'
        }

      def initialize(loan, document)
        @loan = loan
        @document = document
      end

      def execute
        create
      end

      private

      def create
        replace_text('{mutuario_name}', @loan&.client&.fullname)
        street = @loan&.client&.client_address.last&.street || ''
        number_exterior = @loan&.client&.client_address.last&.number_exterior || ''
        number_interior = @loan&.client&.client_address.last&.number_interior || ''
        neighborhood = @loan&.client&.client_address.last&.neighborhood || ''
        code_zip = @loan&.client&.client_address.last&.code_zip || ''
        state_name = @loan&.client&.client_address.last&.state_name || ''
        town = @loan&.client&.client_address.last&.town || ''

        address = "#{street} #{number_exterior} #{number_interior} #{neighborhood} #{code_zip} #{state_name} #{town}"
        replace_text('{mutuario_address}', address)
        replace_text('{loan_amount}', "#{number_to_currency(@loan.amount, precision: 2)} MXN(#{@loan.amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)")

        month = MONTHS[DateTime.now.strftime("%B")]
        date_loan = DateTime.now.strftime("%d de #{month} %Y")

        replace_text('{today_date}', " <b>#{date_loan}</b>")
        
        replace_text('{table_amortization}', "#{table_amortization}")
      end

      def replace_text(key, value)
        @document.gsub!(key, value)
      end

      def capitalize_text(text)
        text.split(' ').collect { |x| x.capitalize}.join(' ')
      end

      def table_amortization
        payments = @loan.payment_personal_groups.order('period ASC')
        table_text = "<table style='width: 100%;'><tbody><tr><td><b># PAGO</b></td><td><b>FECHA PAGO</b></td><td><b>PAGO CAPITAL</b></td><td><b>PAGO INTERES</b></td><td><b>PAGO</b></td></tr>"       

        payments.each do |payment|
          table_text += "<tr><td>#{payment.period}</td><td>#{payment.payment_date&.in_time_zone('Mexico City')&.strftime('%d/%m/%Y')}</td><td>#{number_to_currency(payment.capital_amount, precision: 2)}</td><td>#{number_to_currency(payment.interest_amount, precision: 2)}</td><td>#{number_to_currency(payment.payment_amount, precision: 2)}</td></tr>"
        end
        table_text += "<tr><td><b>TOTALES:</b></td><td></td><td><b>#{number_to_currency(@loan.sum_capital, precision:2)}</b></td><td><b>#{number_to_currency(@loan.sum_interest, precision:2) }</b></td><td><b>#{number_to_currency(@loan.sum_payment_amount, precision:2)}</b></td></tr>"
        table_text += '</tbody></table>'

        table_text
      end
    end
  end
end