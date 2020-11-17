class Interventions < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      t.integer        :author
      t.integer        :customerId
      t.integer        :buildingId
      t.integer        :batteryId
      t.integer        :columnId
      t.integer        :elevatorId
      t.integer        :employeeId
      t.string        :startDateIntervention
      t.string        :endDateIntervention
      t.string        :result, :default => "Incomplete"
      t.string        :reportrake
      t.string        :status, :default => "Pending"
    end
  end
end
