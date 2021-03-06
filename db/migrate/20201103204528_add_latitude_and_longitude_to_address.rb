class AddLatitudeAndLongitudeToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :latitude, :float
    add_column :addresses, :longitude, :float
    add_column :addresses, :full_street_address, :string
  end
end
