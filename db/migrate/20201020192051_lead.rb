class Lead < ActiveRecord::Migration[5.2]
  def change
    create_table :leads do |t|
      t.string      :full_name
      t.string      :company_name
      t.string      :email
      t.string      :phone_number
      t.string      :project_name
      t.string      :project_description
      t.string      :department
      t.text        :message
      t.binary      :attached_file
      t.date        :create_at
    end
  end
end
