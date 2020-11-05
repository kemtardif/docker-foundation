class AddColumnNameAttachedFileToLead < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :name_attached_file, :string
  end
end
