# frozen_string_literal: true

class Transfer < ApplicationRecord
  belongs_to :bank_account

  def amount_cents=(value)
    super(
      case value
      when String
        decimal = BigDecimal(value)
        raise ArgumentError if decimal.scale > 2

        (decimal * 100).to_i
      when Integer
        value
      else
        raise ArgumentError
      end,
    )
  end
end
