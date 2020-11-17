class Intervention < ApplicationRecord
    belongs_to :customer
    belongs_to :building
    belongs_to :battery, :optional => true
    belongs_to :column, :optional => true
    belongs_to :elevator, :optional => true
    
    belongs_to :author, class_name: "Employee", :foreign_key => 'author_id'
    belongs_to :employee, :optional => true, :foreign_key => 'employee_id'

end