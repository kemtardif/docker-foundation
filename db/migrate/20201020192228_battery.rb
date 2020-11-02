class Battery < ActiveRecord::Migration[5.2]
  def change
    create_table :batteries do |t|
      t.string      :type_building
      t.string      :status
      t.date        :date_commissioning
      t.date        :date_last_inspection
      t.string      :cert_ope
      t.string      :information
      t.text        :notes
    end
  end
end
