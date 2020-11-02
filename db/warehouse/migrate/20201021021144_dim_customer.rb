class DimCustomer < ActiveRecord::Migration[5.2]
  def change
    create_table :dim_customers do |t|
      t.date      :creation_date
      t.string    :company_name
      t.string    :cpy_contact_name
      t.string    :cpy_contact_email
      t.integer   :amount_elevator
      t.string    :customer_city
    end
  end
end
