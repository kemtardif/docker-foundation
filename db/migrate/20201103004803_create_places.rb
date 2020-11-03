class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name
      t.decimal :latitude, precision: 15, scale: 13
      t.decimal :longitude, precision: 15, scale: 13

      t.timestamps
    end
  end
end
