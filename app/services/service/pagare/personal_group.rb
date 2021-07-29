module Service
  module Pagare
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

        replace_text('{loan_amount}', "#{number_to_currency(@loan.amount, precision: 2)} MXN")

        month = MONTHS[@loan.end_date.strftime("%B")]
        date_loan = @loan.end_date.strftime("%d de #{month} %Y")

        replace_text('{end_date_loan}', " <b>#{date_loan}</b>") 
      end

      def replace_text(key, value)
        @document.gsub!(key, value)
      end

      def capitalize_text(text)
        text.split(' ').collect { |x| x.capitalize}.join(' ')
      end
    end
  end
end