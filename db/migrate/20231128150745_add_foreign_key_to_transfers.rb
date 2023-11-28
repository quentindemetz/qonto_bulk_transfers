# frozen_string_literal: true

class AddForeignKeyToTransfers < ActiveRecord::Migration[7.1]
  def up
    add_foreign_key :transfers, :bank_accounts, column: :bank_account_id
  end
end
