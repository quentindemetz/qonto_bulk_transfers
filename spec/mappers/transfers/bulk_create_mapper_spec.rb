# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::BulkCreateMapper do
  let(:bank_account) { FactoryBot.create(:bank_account) }

  describe '#call' do
    subject(:call) { described_class.call(bank_account, payload) }

    let(:payload) do
      [
        {
          counterparty_name: Faker::Name.name,
          counterparty_iban: Faker::Bank.iban,
          counterparty_bic: Faker::Bank.swift_bic,
          amount:,
          description: Faker::Lorem.sentence
        }
      ]
    end

    context 'when value is a string' do
      context 'when the string cannot be parsed as a decimal' do
        let(:amount) { 'not a decimal' }

        it 'raises InvalidTransferAmountError' do
          expect { call }.to raise_error(Transfers::BulkCreateMapper::InvalidTransferAmountError)
        end
      end

      context 'when the parsed decimal has more than two decimal places' do
        let(:amount) { '1.234' }

        it 'raises an InvalidTransferAmountError' do
          expect { call }.to raise_error(Transfers::BulkCreateMapper::InvalidTransferAmountError)
        end
      end

      context 'when the parsed decimal has two or less decimal places' do
        let(:amount) { '12.34' }

        it 'sets the relevant attribute with the number of cents' do
          expect(call.first).to have_attributes(amount_cents: 1234)
        end
      end
    end

    context 'when value is an integer' do
      let(:amount) { 12 }

      it 'multiplies the value by 100' do
        transfers = call

        expect(transfers.first).to be_an_instance_of(Transfer)
        expect(transfers.first).to have_attributes(
          amount_cents: 1200,
          bank_account:,
        )
      end
    end

    context 'when value is not a string or integer' do
      let(:amount) { Object.new }

      it 'raises an InvalidTransferAmountError' do
        expect { call }.to raise_error(Transfers::BulkCreateMapper::InvalidTransferAmountError)
      end
    end
  end
end
