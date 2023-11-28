# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransfersController do
  let(:bank_account) { FactoryBot.create(:bank_account, balance_cents: 100_000) }

  describe '#bulk_create' do
    subject(:bulk_create) do
      post :bulk_create, params:
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

      it 'returns a 422 Unprocessable Entity, does not change the balance, does not create transfers' do
        expect do
          bulk_create

          expect(response).to have_http_status(:unprocessable_entity)
        end.to not_change { bank_account.reload.balance_cents }
          .and not_change(Transfer, :count)
      end
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

      it 'returns a 201 Created,, updates the balance, creates the transfers' do
        expect do
          bulk_create

          bank_account.reload

          expect(response).to have_http_status(:created)
        end.to change(bank_account, :balance_cents).from(100_000).to(0)
                                                   .and change(Transfer, :count).by(2)
      end
    end
  end
end
