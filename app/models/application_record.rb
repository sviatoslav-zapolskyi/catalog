class ApplicationRecord < ActiveRecord::Base
  require 'ransack_object'

  self.abstract_class = true
end
