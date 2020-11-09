class FactIntervention < ActiveRecord::Migration[5.2]
  def change
    create_table :fact_intervention do |t|
      t.integer     :employee_id
      t.integer     :building_id
      t.integer     :battery_id               , :null => true
      t.integer     :column_id                 , :null => true
      t.integer     :elevator_id               , :null => true
      t.datetime    :start_date_intervention
      t.datetime    :end_date_intervention      , :null => true
      t.string      :result
      t.text        :report
      t.string      :status
    end
  end
end


# FactIntervention Table :
# EmployeeID
# BuildingID
# BatteryID (Can be null)
# ColumnID (Can be null)
# ElevatorID (Can be null)
# Start date and time of the intervention
# End date and time of the intervention (Can be null)
# Result (Success - Failure - Incomplete)
# Report (Can be null)
# Status (Pending - InProgress - Interrupted - Resumed - Complete)


