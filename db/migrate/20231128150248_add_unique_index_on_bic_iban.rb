# frozen_string_literal: true

class AddUniqueIndexOnBicIban < ActiveRecord::Migration[7.1]
  def up
    add_index :bank_accounts, %i[bic iban], unique: true
  end
end
