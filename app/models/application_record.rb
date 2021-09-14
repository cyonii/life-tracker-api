class ApplicationRecord < ActiveRecord::Base
  default_scope { order(:id) }

  self.abstract_class = true
end
