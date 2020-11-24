require 'csv'
# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)

# # contact_type

# contact_types = ['facebook', 'celular']
# contact_types.each do |contact|
#     ContactType.create!(name: contact, active: true)
# end

# # document_type

# document_types = ['INE', 'CURP', 'comprobante de domicilio']
# document_types.each do |document|
#     DocumentType.create!(name: document, required: true, active: true)
# end

# # movement_type

# movement_types = [
#     {name: 'saldar prestamo', kind_type: :in},
#     {name: 'abono', kind_type: :in},
#     {name: 'garantia', kind_type: :in},
#     {name: 'desembolso', kind_type: :out}
# ]
# movement_types.each do |m|
#     MovementType.create!(name: m[:name], kind_type: m[:kind_type], active: true)
# end


# # role
# main_role = { create: false, update: false, delete: false, show: false}
# Role.create(
#     name: 'gerencia',
#     detail_loan: main_role,
#     group_loan: main_role,
#     state: main_role,
#     movement_type: main_role,
#     loan: main_role,
#     movement: main_role,
#     contact: main_role,
#     document_type: main_role,
#     contact_type: main_role,
#     address: main_role,
#     client: main_role,
#     configuration: main_role,
#     kind_type: main_role,
#     notification: main_role,
#     user: main_role,
#     profile: main_role
# )

# # states

# states = [:pending, :accepted, :finished, :expired]
# states.each do |state|
#     State.create!(name: state, active: true)
# end


# #clients

# file = Rails.root.join('db', 'users.csv')
# clients = CSV.read(file)
# Client.all.order("id DESC").each do |client|
#     if client.id > 51
#         new_id = client.id + 2
#         client.update!(id: new_id)
#     end
# end

# User.create!(username: 'admin', password: 'password', password_confirmation: 'password', role_id: 1) if Rails.env.development?


#contactos clients

# file = Rails.root.join('db', 'contactos.csv')
# contactos = CSV.read(file)
# contactos[1..-1].each do |c|
#     ClientContactType.create!(details: c[0], client_id: c[1], contact_type_id: c[2])
# end



# #Direcciones
# file = Rails.root.join('db', 'address.csv')
# address = CSV.read(file)
# address[1..-1].each do |c|
#     ClientAddress.create!(
#         state_name: c[0],
#         town: c[1],
#         neighborhood: c[2],
#         code_zip: c[3],
#         street: c[4],
#         number_exterior: c[5],
#         number_interior: c[6],
#         client_id: c[7]
#     )
# end


#Direcciones
# file = Rails.root.join('db', 'loans.csv')
# loans = CSV.read(file)
# loans[1..-1].each do |c|
#     state = c[8] || 1
#     Loan.create!(
#         created_at: c[0],
#         name: c[1],
#         loan_amount: c[2],
#         interest_amount: c[3],
#         weekly_amount: c[4],
#         warranty: c[5],
#         start_date: c[6],
#         end_date: c[7],
#         state_id: state,
#         user_id: nil,
#         interest_percent: c[10],
#         cycle: c[12]
#     )
# end


#Weekly  payments
file = Rails.root.join('db', 'weekly_payments.csv')
payments = CSV.read(file)
payments[1..-1].each do |c|
    unless c[8].blank?
        WeeklyPayment.create!(
            week: c[0],
            payment_date: c[1],
            payment_capital: c[2],
            payment_interest: c[3],
            week_payment: c[4],
            balance_capital: c[5],
            wallet_amout: c[6],
            loan_id: c[8]
        )
    end
end













