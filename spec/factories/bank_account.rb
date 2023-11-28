# frozen_string_literal: true

FactoryBot.define do
  factory :bank_account do
    organization_name { Faker::Company.name }
    balance_cents { Faker::Number.number(digits: 5) }
    iban { Faker::Bank.iban }
    bic { Faker::Bank.swift_bic }
  end
end
