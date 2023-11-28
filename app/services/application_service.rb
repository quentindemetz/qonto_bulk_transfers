# frozen_string_literal: true

class ApplicationService
  def self.call(*, **, &)
    new(*, **).send(:call, &)
  end
end
