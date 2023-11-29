# frozen_string_literal: true

RSpec.describe Transfers::BulkCreateService do
  let(:bank_account) { FactoryBot.create(:bank_account, balance_cents:) }

  let(:credit_transfers) do
    [
      Transfer.new(
        counterparty_name: Faker::Name.name,
        counterparty_iban: Faker::Bank.iban,
        counterparty_bic: Faker::Bank.swift_bic,
        amount_cents: first_transfer_amount_cents,
        description: Faker::Lorem.sentence,
        bank_account:,
      ),
      Transfer.new(
        counterparty_name: Faker::Name.name,
        counterparty_iban: Faker::Bank.iban,
        counterparty_bic: Faker::Bank.swift_bic,
        amount_cents: second_transfer_amount_cents,
        description: Faker::Lorem.sentence,
        bank_account:,
      )
    ]
  end

  describe '#call' do
    context 'when the bank account has enough balance' do
      let(:balance_cents) { 1500 }
      let(:first_transfer_amount_cents) { 1000 }
      let(:second_transfer_amount_cents) { 500 }

      it 'updates the account balance and creates the transfers' do
        expect do
          described_class.call(bank_account, credit_transfers)
          bank_account.reload
        end.to change(bank_account, :balance_cents).from(1500).to(0)
           .and change(Transfer, :count).by(2)
      end
    end

    context 'when the bank account does not have enough balance' do
      let(:balance_cents) { 1500 }
      let(:first_transfer_amount_cents) { 1000 }
      let(:second_transfer_amount_cents) { 600 }

      it 'raises an InsufficientBalanceError, and does not change the data' do
        expect do
          described_class.call(bank_account, credit_transfers)
        end.to raise_error(Transfers::BulkCreateService::InsufficientBalanceError)
          .and not_change { bank_account.reload.balance_cents }
          .and not_change(Transfer, :count)
      end
    end

    context 'when the lock fails to be acquired' do
      let(:balance_cents) { 1500 }
      let(:first_transfer_amount_cents) { 1000 }
      let(:second_transfer_amount_cents) { 600 }

      it 'raises an OperationInProgressError, and does not change the data' do
        expect(BankAccount).to receive(:lock).and_raise(ActiveRecord::LockWaitTimeout)

        expect do
          described_class.call(bank_account, credit_transfers)
        end.to raise_error(Transfers::BulkCreateService::OperationInProgressError)
          .and not_change { bank_account.reload.balance_cents }
          .and not_change(Transfer, :count)
      end
    end
  end
end
