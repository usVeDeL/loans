class Role < ApplicationRecord
    serialize :detail_loan
    serialize :group_loan
    serialize :state
    serialize :movement_type
    serialize :loan
    serialize :movement
    serialize :contact
    serialize :document_type
    serialize :contact_type
    serialize :address
    serialize :client
    serialize :configuration
    serialize :kind_type
    serialize :notification
    serialize :user
    serialize :profile

    validates :name, uniqueness: { case_sensitive: false }, presence: true
end