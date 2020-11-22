class MovementType < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :kind_type, presence: true
  has_many :loan_movements
  enum kind_type: {
    in: 'in',
    out: 'out'
  }

  def mov_type
    if self.kind_type == 'in'
      'Ingreso'
    else
      'Egreso'
    end
  end
end
