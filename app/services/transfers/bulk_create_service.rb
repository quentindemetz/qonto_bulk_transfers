# frozen_string_literal: true

module Transfers
  class BulkCreateService < ::ApplicationService
    class OperationInProgressError < StandardError; end
    class InsufficientBalanceError < StandardError; end

    private

    def initialize(bank_account, credit_transfers)
      @bank_account = bank_account
      @credit_transfers = credit_transfers
    end

    def call
      @bank_account.update!(
        balance_cents: @bank_account.balance_cents - @credit_transfers.sum(&:amount_cents),
      )
      ::Transfer.import!(
        @credit_transfers,
      )
    end
  end
end
