# frozen_string_literal: true

class BankAccount < ApplicationRecord
  has_many :transfers, dependent: :restrict_with_error
end
