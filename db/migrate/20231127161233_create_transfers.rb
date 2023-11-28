# frozen_string_literal: true

class CreateTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :transfers do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.text :counterparty_name, null: true
      t.text :counterparty_iban, null: true
      t.text :counterparty_bic, null: true
      t.integer :amount_cents, null: true
      t.integer :bank_account_id, null: true
      t.text :description, null: true
    end
  end
end
