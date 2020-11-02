class BuildingsDetail < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings_details do |t|
      t.string :info_key
      t.string :value
    end
  end
end
