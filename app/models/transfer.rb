# frozen_string_literal: true

class Transfer < ApplicationRecord
  belongs_to :bank_account

  validates(
    :counterparty_name,
    :counterparty_iban,
    :counterparty_bic,
    :amount_cents,
    :description,
    presence: true,
  )

  validates :amount_cents, numericality: { greater_than: 0 }
end
