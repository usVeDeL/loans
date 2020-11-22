require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# contact_type

contact_types = ['facebook', 'celular']
contact_types.each do |contact|
    ContactType.create!(name: contact, active: true)
end

# document_type

document_types = ['INE', 'CURP', 'comprobante de domicilio']
document_types.each do |document|
    DocumentType.create!(name: document, required: true, active: true)
end

# movement_type

movement_types = [
    {name: 'saldar prestamo', kind_type: :in},
    {name: 'abono', kind_type: :in},
    {name: 'garantia', kind_type: :in},
    {name: 'desembolso', kind_type: :out}
]
movement_types.each do |m|
    MovementType.create!(name: m[:name], kind_type: m[:kind_type], active: true)
end


# role
main_role = { create: false, update: false, delete: false, show: false}
Role.create(
    name: 'gerencia',
    detail_loan: main_role,
    group_loan: main_role,
    state: main_role,
    movement_type: main_role,
    loan: main_role,
    movement: main_role,
    contact: main_role,
    document_type: main_role,
    contact_type: main_role,
    address: main_role,
    client: main_role,
    configuration: main_role,
    kind_type: main_role,
    notification: main_role,
    user: main_role,
    profile: main_role
)

# states

states = [:pending, :accepted, :finished, :expired]
states.each do |state|
    State.create!(name: state, active: true)
end


#clients

file = Rails.root.join('db', 'users.csv')
clients = CSV.read(file)
clients[1..-1].each do |client|
    client = Client.new(name: client[1], last_name: client[2], mother_last_name: client[3], birth_date: client[4].to_datetime)
    client.save!
    if client.id > 51
        new_id = client.id + 2
        client.update!(id: new_id)
    end
end

User.create!(username: 'admin', password: 'password', password_confirmation: 'password', role_id: 1) if Rails.env.development?

