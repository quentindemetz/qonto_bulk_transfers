# frozen_string_literal: true

class FixDatabaseConsistencyOffenses < ActiveRecord::Migration[7.1]
  def up
    change_column_null :transfers, :bank_account_id, false
    add_index :transfers, :bank_account_id
  end
end
