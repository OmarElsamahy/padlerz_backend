class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # include GeneralHelper
  # include DateValidators
end
