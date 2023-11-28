# frozen_string_literal: true

FactoryBot.define do
  factory :transfer do
    counterparty_name { Faker::Name.name }
    counterparty_iban { Faker::Bank.iban }
    counterparty_bic { Faker::Bank.swift_bic }
    amount_cents { Faker::Number.number(digits: 5) }
    description { Faker::Lorem.sentence }

    association(:bank_account)
  end
end
