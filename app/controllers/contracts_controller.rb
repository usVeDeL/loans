class ContractsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    @contracts = Contract.all
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)

    if @contract.save
      flash[:success] = "Cambios guardados correctamente"
      redirect_to contracts_path
    else
      render 'new'
    end
  end

  def edit
    @contract = Contract.find(params[:id])
  end

  def update
    @contract = Contract.find(params[:id])

    if @contract.update(contract_params)
      flash[:success] = "Cambios guardados correctamente"
      redirect_to contracts_path
    else
      render 'edit'
    end
  end

  def destroy
    contract = Contract.find(params[:id])

    if contract.delete
      flash[:success] = 'Cambios guardados correctamente'
      redirect_to contracts_path
    else
      flash[:danger] = 'Error... algo salio mal'
      redirect_to contracts_path
    end
  end

  def download_contract
    @loan = Loan.find params[:id]
    respond_to do |format|
      format.html
      format.pdf do

        @contract = get_contract 
        render pdf: "contrato.pdf",
        template: "contracts/download_contract.html.erb",
        layout: 'download_contract.html.erb'
      end
    end
  end

  def download_pagare
    @loan = Loan.find params[:id]
    respond_to do |format|
      format.html
      format.pdf do

        @contract = get_pagare 
        render pdf: "pagare.pdf",
        template: "contracts/download_pagare.html.erb",
        layout: 'download_pagare.html.erb'
      end
    end
  end

  private

  def get_contract
    contract = Contract.find_by(name: 'contrato').content_text
    mutuarios = @loan.clients.map{ |c| "#{c.name} #{c.last_name} #{c.mother_last_name}"}.join(', ')

    mutuarios_address = @loan.clients.map do |c| 
      street = c.client_address&.last&.street || ''
      number_exterior = c.client_address&.last&.number_exterior || ''
      number_interior = c.client_address&.last&.number_interior || ''
      neighborhood = c.client_address&.last&.neighborhood || ''
      code_zip = c.client_address&.last&.code_zip || ''
      state_name = c.client_address&.last&.state_name || ''
      town = c.client_address&.last&.town || ''

      "<b>#{c.name} #{c.last_name} #{c.mother_last_name}</b> - #{street} #{number_exterior} #{number_interior} #{neighborhood} #{code_zip} #{state_name} #{town}"
    end.join('<br/>')

    mutuarios_loans = @loan.loan_clients.map do |l| 
      c = l.client
      "<b>#{c.name} #{c.last_name} #{c.mother_last_name}</b> - #{number_to_currency(l.amount, precision: 2)} MXN(#{l.amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)"
    end.join('<br/>')

    mutuarios_signatures = @loan.clients.map do |c|
      "<b>#{c.name} #{c.last_name} #{c.mother_last_name}</b><br/><br>___________________________________________<br><br><br><br>"
    end.join('<br/>')


    contract.gsub!('{mutuante}', '<b>C. SAUL DEL RAZO GARCIA</b>')
    contract.gsub!('{mutuante_address}', '<b>calle Av.Melchor Ocampo numero 27 interior B Planta Alta Col. Infonavit Nuevo Horizonte</b>')
    contract.gsub!('{mutuarios}', " <b>CC. #{mutuarios}</b>")
    contract.gsub!('{mutuarios_address}', mutuarios_address)
    contract.gsub!('{loan_amount}', "#{number_to_currency(@loan.loan_amount, precision: 2)} MXN(#{@loan.loan_amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)")
    contract.gsub!('{loan_clients_details}', mutuarios_loans)
    contract.gsub!('{signatures_mutuarios}', mutuarios_signatures)
  end

  def get_pagare
    contract = Contract.find_by(name: 'pagare').content_text

    mutuarios_address = @loan.clients.map do |c| 
      street = c.client_address.last&.street || ''
      number_exterior = c.client_address.last&.number_exterior || ''
      number_interior = c.client_address.last&.number_interior || ''
      neighborhood = c.client_address.last&.neighborhood || ''
      code_zip = c.client_address.last&.code_zip || ''
      state_name = c.client_address.last&.state_name || ''
      town = c.client_address.last&.town || ''

      "<b>#{c.name} #{c.last_name} #{c.mother_last_name}</b> - #{street} #{number_exterior} #{number_interior} #{neighborhood} #{code_zip} #{state_name} #{town}"
    end.join('<br/>')


    mutuarios_signatures = @loan.clients.map do |c|
      "<b>#{c.name} #{c.last_name} #{c.mother_last_name}</b><br/><br>___________________________________________<br><br><br><br>"
    end.join('<br/>')


    contract.gsub!('{mutuante}', ' <b>C. SAUL DEL RAZO GARCIA</b>')
    contract.gsub!('{mutuarios_address}', mutuarios_address)
    contract.gsub!('{loan_amount}', "#{number_to_currency(@loan.loan_amount, precision: 2)} MXN")
    contract.gsub!('{loan_amount_with_letter}', "#{number_to_currency(@loan.loan_amount, precision: 2)} MXN(#{@loan.loan_amount.humanize(locale: :es).upcase} PESOS 00/100 MXN.)")
    contract.gsub!('{signatures_mutuarios}', mutuarios_signatures)
    contract.gsub!('{loan_due_date}', " <b>#{@loan.end_date&.strftime('%F')}</b>") 
  end

  def contract_params
    params.require(:contract).permit(:name, :content_text)
  end
end
