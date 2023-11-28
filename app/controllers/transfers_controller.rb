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
  rescue Transfers::BulkCreateService::OperationInProgressError
    render head: :conflict
  rescue Transfers::BulkCreateService::InsufficientBalanceError
    render head: :unprocessable_entity
  else
    render head: :created
  end

  private

  def credit_transfers_for(bank_account)
    params[:credit_transfer].map do |credit_transfer|
      Transfer.new(
        counterparty_name: credit_transfer[:counterparty_name],
        counterparty_iban: credit_transfer[:counterparty_iban],
        counterparty_bic: credit_transfer[:counterparty_bic],
        amount_cents: credit_transfer[:amount],
        description: credit_transfer[:description],
        bank_account:,
      )
    end
  end
end
