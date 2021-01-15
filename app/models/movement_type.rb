class MovementType < ApplicationRecord
  has_many :loan_movements

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :kind_type, presence: true

  enum kind_type: {
    in: 'in',
    out: 'out'
  }

  def type
    return 'Ingreso' if self.kind_type == 'in'
    
    'Egreso'
  end
end
