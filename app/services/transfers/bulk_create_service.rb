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
      BankAccount.transaction do
        @bank_account.decrement!(:balance_cents, @credit_transfers.sum(&:amount_cents)) # rubocop:disable Rails/SkipsModelValidations

        ::Transfer.import!(
          @credit_transfers,
        )
      end
    rescue SQLite3::ConstraintException
      raise InsufficientBalanceError
    end
  end
end
