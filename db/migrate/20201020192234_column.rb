class Column < ActiveRecord::Migration[5.2]
  def change
    create_table :columns do |t|
      t.string    :type_building
      t.integer   :amount_floors_served
      t.string    :status
      t.string    :information
      t.text      :notes
    end
  end
end
