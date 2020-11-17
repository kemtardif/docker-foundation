class Interventions < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      t.integer        :author
      t.datetime       :startDateIntervention
      t.datetime       :endDateIntervention
      t.string         :result, :default => "Incomplete"
      t.string         :report
      t.string         :status, :default => "Pending"
    end

    add_reference :interventions, :building, foreign_key: true
    add_reference :interventions, :battery, foreign_key: true
    add_reference :interventions, :column, foreign_key: true
    add_reference :interventions, :elevator, foreign_key: true
    add_reference :interventions, :employee, foreign_key: true
    add_reference :interventions, :customer, foreign_key: true
  end
end
