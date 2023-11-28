# frozen_string_literal: true

class BankAccount < ApplicationRecord
  has_many :transfers, dependent: :restrict_with_error

  validates(
    :organization_name,
    :iban,
    :bic,
    :balance_cents,
    presence: true,
  )

  validates :balance_cents, numericality: { greater_than: 0 }
end
