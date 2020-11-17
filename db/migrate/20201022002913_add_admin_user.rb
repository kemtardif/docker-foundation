class AddAdminUser < ActiveRecord::Migration[5.2]
  def change
    user_ = User.new
    user_.email = "kem@tardif.com"
    user_.password = "password"
    user_.add_role :admin
    user_.save!
  end
end
