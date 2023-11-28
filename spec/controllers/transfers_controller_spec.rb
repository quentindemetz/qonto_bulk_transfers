# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransfersController do
  let(:bank_account) do
    FactoryBot.create(
      :bank_account,
      balance_cents:,
      bic: 'OIVUSCLQXXX',
      iban: 'FR10474608000002006107XXXXX',
    )
  end

  let(:balance_cents) { 100_000 }

  describe '#bulk_create' do
    subject(:bulk_create) do
      post :bulk_create, params:
    end

    shared_examples 'sufficient balance' do |transfer_count:, balance_change:|
      it 'returns a 201 Created, updates the balance, creates transfers' do
        expect do
          bulk_create

          bank_account.reload

          expect(response).to have_http_status(:created)
        end.to change(bank_account, :balance_cents).by(balance_change)
                                                   .and change(Transfer, :count).by(transfer_count)
      end
    end

    shared_examples 'insufficient balance' do
      it 'returns a 422 Unprocessable Entity, does not change the balance, does not create transfers' do
        expect do
          bulk_create

          expect(response).to have_http_status(:unprocessable_entity)
        end.to not_change { bank_account.reload.balance_cents }
          .and not_change(Transfer, :count)
      end
    end

    context 'when the bank account does not exist' do
      let(:params) do
        {
          organization_bic: "#{bank_account.bic}FOO",
          organization_iban: "#{bank_account.iban}BAR",
          credit_transfers: []
        }
      end

      it 'returns a 404 Not Found' do
        bulk_create

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the credit transfers have an invalid format' do
      let(:params) do
        {
          organization_bic: bank_account.bic,
          organization_iban: bank_account.iban,
          credit_transfers: [
            {
              counterparty_name: Faker::Name.name,
              counterparty_iban: Faker::Bank.iban,
              counterparty_bic: Faker::Bank.swift_bic,
              amount: '1.234',
              description: Faker::Lorem.sentence
            }
          ]
        }
      end

      it 'returns a 400 Bad Request' do
        bulk_create

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when the bank account balance is insufficient' do
      let(:params) do
        {
          organization_bic: bank_account.bic,
          organization_iban: bank_account.iban,
          credit_transfers: [
            {
              counterparty_name: Faker::Name.name,
              counterparty_iban: Faker::Bank.iban,
              counterparty_bic: Faker::Bank.swift_bic,
              amount: '2000.01',
              description: Faker::Lorem.sentence
            }
          ]
        }
      end

      include_examples 'insufficient balance'
    end

    context 'when the bank account balance is sufficient' do
      let(:params) do
        {
          organization_bic: bank_account.bic,
          organization_iban: bank_account.iban,
          credit_transfers: [
            {
              counterparty_name: Faker::Name.name,
              counterparty_iban: Faker::Bank.iban,
              counterparty_bic: Faker::Bank.swift_bic,
              amount: '750.00',
              description: Faker::Lorem.sentence
            },
            {
              counterparty_name: Faker::Name.name,
              counterparty_iban: Faker::Bank.iban,
              counterparty_bic: Faker::Bank.swift_bic,
              amount: '250.00',
              description: Faker::Lorem.sentence
            }
          ]
        }
      end

      include_examples 'sufficient balance', transfer_count: 2, balance_change: -100_000
    end

    context 'with sample1.json' do
      let(:params) { JSON.parse(file_fixture('sample1.json').read) }

      context 'when the account balance is sufficient' do
        let(:balance_cents) { 63_000_00 }

        include_examples 'sufficient balance', transfer_count: 3, balance_change: -62_251_50
      end

      context 'when the account balance is insufficient' do
        let(:balance_cents) { 10 }

        include_examples 'insufficient balance'
      end
    end

    context 'with sample2.json' do
      let(:params) { JSON.parse(file_fixture('sample2.json').read) }

      context 'when the account balance is sufficient' do
        let(:balance_cents) { 107_000_00 }

        include_examples 'sufficient balance', transfer_count: 4, balance_change: -106_482_16
      end

      context 'when the account balance is insufficient' do
        let(:balance_cents) { 10 }

        include_examples 'insufficient balance'
      end
    end
  end
end
