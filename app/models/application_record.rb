class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Discard::Model
  self.discard_column = :deleted_at
end
