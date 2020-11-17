class Column < ApplicationRecord
    belongs_to  :battery
    has_many    :elevators
    has_many :interventions
end
