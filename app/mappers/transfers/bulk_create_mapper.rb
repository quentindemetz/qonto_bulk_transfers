# frozen_string_literal: true

module Transfers
  class BulkCreateMapper < ::ApplicationService
    class InvalidTransferAmountError < ActiveRecord::RecordInvalid; end

    private

    def initialize(bank_account, credit_transfers)
      @bank_account = bank_account
      @credit_transfers = credit_transfers
    end

    def call
      @credit_transfers.map do |credit_transfer|
        ::Transfer.new(
          counterparty_name: credit_transfer[:counterparty_name],
          counterparty_iban: credit_transfer[:counterparty_iban],
          counterparty_bic: credit_transfer[:counterparty_bic],
          amount_cents: convert_amount_into_cents(credit_transfer[:amount]),
          description: credit_transfer[:description],
          bank_account: @bank_account,
        ).tap(&:validate!)
      end
    end

    def convert_amount_into_cents(value)
      case value
      when String
        decimal = BigDecimal(value)

        raise InvalidTransferAmountError if decimal.scale > 2

        (decimal * 100).to_i
      when Integer
        value * 100
      else
        raise InvalidTransferAmountError
      end
    rescue ArgumentError
      raise InvalidTransferAmountError
    end
  end
end
