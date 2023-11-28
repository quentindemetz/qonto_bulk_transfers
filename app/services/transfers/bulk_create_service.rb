# frozen_string_literal: true

module Transfers
  class BulkCreateService < ::ApplicationService
    class OperationInProgressError < StandardError; end
    class InsufficientBalanceError < StandardError; end

    private

    def initialize(bank_account, _credit_transfers)
      @bank_account = bank_account
      @credit_transfers = bulk_transfers
    end

    def call; end
  end
end
