class Priority < ApplicationRecord
  default_scope { order('level DESC') } 
end
