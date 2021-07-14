module IncludeParams
  include ActiveSupport::Concern

  def self.include_fields(include, allowed)
    allowed = allowed.map(&:to_s)
    fields = include.to_s.split(",")

    filtered_fields = fields.select { |key, value|
      allowed.include?(key)
    }

    filtered_fields
  end
end