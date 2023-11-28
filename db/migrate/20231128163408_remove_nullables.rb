# frozen_string_literal: true

class RemoveNullables < ActiveRecord::Migration[7.1]
  def up
    change_column_null :bank_accounts, :organization_name, false
    change_column_null :bank_accounts, :balance_cents, false
    change_column_null :bank_accounts, :iban, false
    change_column_null :bank_accounts, :bic, false
    change_column_null :transfers, :counterparty_name, false
    change_column_null :transfers, :counterparty_iban, false
    change_column_null :transfers, :counterparty_bic, false
    change_column_null :transfers, :amount_cents, false
    change_column_null :transfers, :description, false
  end
end
