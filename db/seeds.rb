# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

return unless Rails.env.development?

Transfer.delete_all
BankAccount.delete_all

BankAccount.create!(
  id: 1,
  organization_name: 'ACME Corp',
  balance_cents: 10_000_000,
  iban: 'FR10474608000002006107XXXXX',
  bic: 'OIVUSCLQXXX',
)

Transfer.create!(
  id: 1,
  counterparty_name: 'ACME Corp. Main Account',
  counterparty_iban: 'EE382200221020145685',
  counterparty_bic: 'CCOPFRPPXXX',
  amount_cents: 11_000_000,
  description: 'Treasury management',
  bank_account_id: 1,
)

Transfer.create!(
  id: 2,
  counterparty_name: 'Bip Bip',
  counterparty_iban: 'EE383680981021245685',
  counterparty_bic: 'CRLYFRPPTOU',
  amount_cents: 1_000_000,
  description: 'Bip Bip Salary',
  bank_account_id: 1,
)
