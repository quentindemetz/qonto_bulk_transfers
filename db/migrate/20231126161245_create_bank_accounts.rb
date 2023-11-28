# frozen_string_literal: true

class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.text :organization_name, null: true
      t.integer :balance_cents, null: true
      t.text :iban, null: true
      t.text :bic, null: true
    end
  end
end
