class Quote < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes do |t|
      t.string  :company_name
      t.string  :building_type
      t.integer :apps_qty
      t.integer :floors_qty
      t.integer :basements_qty
      t.integer :parkings_qty
      t.integer :elevators_qty
      t.integer :business_qty
      t.integer :occupants_floors_qty
      t.integer :hours_activity
      t.string  :game
      t.integer :elevator_needed
      t.integer :total_price
      t.string  :email
      t.date    :create_at
    end
  end
end
