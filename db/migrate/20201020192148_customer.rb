class Customer < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.date          :date_create
      t.string        :company_name
      t.string        :cpy_contact_name
      t.string        :cpy_contact_phone
      t.string        :cpy_contact_email
      t.string        :cpy_description
      t.string        :sta_name
      t.string        :sta_phone
      t.string        :sta_mail
    end
  end
end
