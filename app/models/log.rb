class Log < ApplicationRecord
  belongs_to :user

  delegate :name, :last_name, :mother_last_name, to: :user, prefix: true
end
