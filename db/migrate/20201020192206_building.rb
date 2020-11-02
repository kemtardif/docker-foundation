class Building < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings do |t|
      t.string        :adm_contact_name
      t.string        :adm_contact_mail
      t.string        :adm_contact_phone
      t.string        :tect_contact_name
      t.string        :tect_contact_email
      t.string        :tect_contact_phone
    end
  end
end
