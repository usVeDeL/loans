class State < ApplicationRecord
  validates :name, presence: true

  enum name: {
    pending: 'pending',
    accepted: 'accepted',
    finished: 'finished',
    expired: 'expired'
  }
  STATES_NAMES = {
    pending: 'pendiente',
    accepted: 'aceptado',
    finished: 'finalizado',
    expired: 'vencido'
  }

  def state_name
    STATES_NAMES[self.name.to_sym]
  end
end
