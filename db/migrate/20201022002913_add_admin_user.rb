class AddAdminUser < ActiveRecord::Migration[5.2]
  def change
    user_ = User.new
    user_.email = "admin@tonted.xyz"
    user_.password = "password"
    user_.add_role :admin
    user_.save!
  end
end
