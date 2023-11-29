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
        BankAccount
          .lock('FOR UPDATE NOWAIT')
          .find(@bank_account.id)
          .decrement!(:balance_cents, @credit_transfers.sum(&:amount_cents)) # rubocop:disable Rails/SkipsModelValidations

        ::Transfer.import!(
          @credit_transfers,
        )
      end
    rescue ActiveRecord::LockWaitTimeout
      raise OperationInProgressError
    rescue ActiveRecord::StatementInvalid => e
      case e.cause
      when SQLite3::ConstraintException
        raise InsufficientBalanceError
      else
        raise e
      end
    end
  end
end
