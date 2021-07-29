class ContractsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]

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

  def index
    @contracts = Contract.all
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)

    if @contract.save
      create_log("Se ha creado el documento de nombre: #{@contract.name}.")

      flash[:success] = success_text

      redirect_to contracts_path
    else
      render 'new'
    end
  end

  def edit
    @contract = contract
  end

  def update
    @contract = contract

    if @contract.update(contract_params)
      flash[:success] = success_text

      redirect_to contracts_path
    else
      render 'edit'
    end
  end

  def destroy
    if contract.delete
      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to contracts_path
  end

  def download_contract
    download_document('contract', Contract.find(1).content_text)
  end

  def download_pagare
    download_document('pagare', Contract.find(2).content_text)
  end

  def download_personal_group_contract
    document = Service::Contract::PersonalGroup.new(personal_group_loan, contract_by_name).execute
    download_document_2('contract', document)
  end

  def download_personal_group_pagare
    document = Service::Pagare::PersonalGroup.new(personal_group_loan, contract_by_name).execute
    download_document_2('pagare', document)
  end

  private

  def print_contract
    mutuarios = @loan.clients.map{ |c| "#{capitalize_text(c.name)} #{capitalize_text(c.last_name)} #{capitalize_text(c.mother_last_name)}"}.join(', ')
    mutuarios_address = '<ul>'
    month = MONTHS[@loan.disbursement_date.strftime("%B")]
    date_loan = @loan.disbursement_date.strftime("%d de #{month} %Y")
    mutuarios_address += @loan.clients.map do |c|
      street = c.client_address&.last&.street || ''
      number_exterior = c.client_address&.last&.number_exterior || ''
      number_interior = c.client_address&.last&.number_interior || ''
      neighborhood = c.client_address&.last&.neighborhood || ''
      code_zip = c.client_address&.last&.code_zip || ''
      state_name = c.client_address&.last&.state_name || ''
      town = c.client_address&.last&.town || ''

      "<li><b>#{capitalize_text(c.name)} #{capitalize_text(c.last_name)} #{capitalize_text(c.mother_last_name)}</b> - #{street} #{number_exterior} #{number_interior} #{neighborhood} #{code_zip} #{state_name} #{town}</li>"
    end.join('<br/>')

    mutuarios_address += '</ul>'

    mutuarios_loans = @loan.loan_clients.map do |l| 
      c = l.client
      "<b>#{capitalize_text(c.name)} #{capitalize_text(c.last_name)} #{capitalize_text(c.mother_last_name)}</b> - #{number_to_currency(l.amount, precision: 2)} MXN(#{l.amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)"
    end.join('<br/><br/>')

    mutuarios_signatures = @loan.clients.map do |c|
      "<b>#{capitalize_text(c.name)} #{capitalize_text(c.last_name)} #{capitalize_text(c.mother_last_name)}</b><br/><br>___________________________________________<br><br><br><br>"
    end.join('<br/>')

    address_contract = @loan.address_contract
    address_contract = 'calle Av.Melchor Ocampo numero 27 interior B Planta Alta Col. Infonavit Nuevo Horizonte' if address_contract.blank?

    replace_text('{mutuante}', '<b>C. SAUL DEL RAZO GARCIA</b>')
    replace_text('{mutuante_address}', "<b>#{address_contract}</b>")
    replace_text('{mutuarios}', " <b>CC. #{mutuarios}</b>")
    replace_text('{mutuarios_address}', mutuarios_address)
    replace_text('{loan_amount}', "#{number_to_currency(@loan.loan_amount, precision: 2)} MXN(#{@loan.loan_amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)")
    replace_text('{loan_clients_details}', mutuarios_loans)
    replace_text('{signatures_mutuarios}', mutuarios_signatures)
    replace_text('{date_loan}', date_loan)
  end

  def print_pagare
    mutuarios_address = '<ul>'

    mutuarios_address += @loan.clients.map do |c|
      street = c.client_address.last&.street || ''
      number_exterior = c.client_address.last&.number_exterior || ''
      number_interior = c.client_address.last&.number_interior || ''
      neighborhood = c.client_address.last&.neighborhood || ''
      code_zip = c.client_address.last&.code_zip || ''
      state_name = c.client_address.last&.state_name || ''
      town = c.client_address.last&.town || ''

      "<li><b>#{capitalize_text(c.name)} #{capitalize_text(c.last_name)} #{capitalize_text(c.mother_last_name)}</b> - #{street} #{number_exterior} #{number_interior} #{neighborhood} #{code_zip} #{state_name} #{town}</li>"
    end.join('<br/>')

    mutuarios_address += '</ul><br><br>'
    mutuarios_signatures = @loan.clients.map do |c|
      "<b>#{capitalize_text(c.name)} #{capitalize_text(c.last_name)} #{capitalize_text(c.mother_last_name)}</b><br/><br>___________________________________________<br><br><br><br>"
    end.join('<br/>')

    replace_text('{mutuante}', ' <b>C. SAUL DEL RAZO GARCIA</b>')
    replace_text('{mutuarios_address}', mutuarios_address)
    replace_text('{loan_amount}', "#{number_to_currency(@loan.loan_amount, precision: 2)} MXN")
    replace_text('{loan_amount_with_letter}', "#{number_to_currency(@loan.loan_amount, precision: 2)} MXN(#{@loan.loan_amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)")
    replace_text('{signatures_mutuarios}', mutuarios_signatures)
    replace_text('{loan_due_date}', " <b>#{@loan.end_date&.strftime('%d/%m/%Y')}</b>") 
  end

  def replace_text(key, value)
    @contract_text.gsub!(key, value)
  end

  def contract
    Contract.find(params[:id])
  end

  def contract_by_name
    Contract.find_by(name: params[:name]).content_text
  end

  def contract_params
    params.require(:contract).permit(
      :name,
      :content_text
    )
  end

  def capitalize_text(text)
    text.split(' ').collect { |x| x.capitalize}.join(' ')
  end

  def download_document(type, contract)
    @loan = loan
    respond_to do |format|
      format.html
      format.pdf do

        @contract = print_document(type, contract)
        render pdf: "#{type}.pdf",
        template: "contracts/download_#{type}.html.erb",
        layout: "download_#{type}.html.erb",
        page_size: 'A4',
        encoding: 'UTF-8',
        margin: {
          top: 20,
          left: 20,
          right: 20
        }
      end
    end
  end

  def download_document_2(type, document)
    @loan = loan
    respond_to do |format|
      format.html
      format.pdf do
        @contract = document
        render pdf: "#{type}.pdf",
        template: "contracts/download_#{type}.html.erb",
        layout: "download_#{type}.html.erb",
        page_size: 'A4',
        encoding: 'UTF-8',
        margin: {
          top: 20,
          left: 20,
          right: 20
        }
      end
    end
  end

  def loan
    Loan.find params[:id]
  end

  def personal_group_loan
    PersonalGroupLoan.find params[:id]
  end

  def print_document(type, contract)
    @contract_text = contract
    type == 'contract' ? print_contract : print_pagare
  end
end
