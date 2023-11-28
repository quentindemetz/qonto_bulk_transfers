# frozen_string_literal: true

class TransfersController < ApplicationController
  def bulk_create
    bank_account = BankAccount.find_by!(
      organization_bic: params[:organization_bic],
      organization_iban: params[:organization_iban],
    )

    Transfers::BulkCreateService.call(
      bank_account,
      credit_transfers_for(bank_account),
    )
  rescue ActiveRecord::RecordInvalid
    render head: :bad_request
  rescue Transfers::BulkCreateService::OperationInProgressError
    render head: :conflict
  rescue Transfers::BulkCreateService::InsufficientBalanceError
    render head: :unprocessable_entity
  else
    render head: :created
  end

  private

  def credit_transfers_for(bank_account)
    Transfers::BulkCreateMapper.call(
      bank_account,
      params[:credit_transfers],
    )
  end
end
