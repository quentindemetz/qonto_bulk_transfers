# frozen_string_literal: true

class AddCheckConstraintOnAccountBalance < ActiveRecord::Migration[7.1]
  def up
    add_check_constraint :bank_accounts, 'balance_cents >= 0'
  end
end
