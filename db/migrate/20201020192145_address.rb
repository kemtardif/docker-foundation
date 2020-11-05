class Address < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string      :type_address
      t.string      :status
      t.string      :entite
      t.string      :address
      t.string      :address2
      t.string      :city
      t.string      :postal_code
      t.string      :country
      t.text        :notes  
    end
  end
end