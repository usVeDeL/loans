class TransactionsController < ApplicationController
  def create(amount: nil, loan_id: nil, loan_movement_id: nil)
    movement = loan_movement(loan_movement_id)
    transaction = find_transaction(movement_id: movement.id, week: movement&.week)
    if transaction
      transaction.update!(amount: transaction.amount + amount&.to_f)
    else 
      transaction = Transaction.new(
        amount: amount&.to_f,
        loan_id: loan_id,
        loan_movement_id: movement.id,
        week: movement.week
      )
      
      transaction.save!
    end
  end

  private

  def loan_movement(id)
    LoanMovement.find(id)
  end

  def find_transaction(movement_id: nil, week: nil)
    Transaction.find_by(week: week, loan_movement_id: movement_id)
  end
end 
