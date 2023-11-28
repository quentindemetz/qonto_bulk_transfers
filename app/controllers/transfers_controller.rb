# frozen_string_literal: true

class TransfersController < ApplicationController
  def bulk_create
    bank_account = BankAccount.find_by!(
      bic: params[:organization_bic],
      iban: params[:organization_iban],
    )

    Transfers::BulkCreateService.call(
      bank_account,
      credit_transfers_for(bank_account),
    )
  rescue Transfers::BulkCreateService::OperationInProgressError
    render status: :conflict
  rescue Transfers::BulkCreateService::InsufficientBalanceError
    render status: :unprocessable_entity
  else
    render status: :created
  end

  private

  def credit_transfers_for(bank_account)
    Transfers::BulkCreateMapper.call(
      bank_account,
      params[:credit_transfers],
    )
  end
end
