class Employee < ApplicationRecord
  belongs_to :user
  has_many :batteries
  
  has_many :interventions

  def fullName
    self.first_name + " " + self.last_name
  end

end
