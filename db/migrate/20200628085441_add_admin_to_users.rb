class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :admin, :boolean, null: false, default: false

    User.create! do |u|
      u.email = 'admin@cookgram.com'
      u.password = '123456789'
      u.fname = 'Ngoc'
      u.lname = 'Anh'
      u.admin = true
    end
  end

  def self.down
    remove_column :users, :admin
    User.find_by_email('admin@@cookgram.com').try(:delete)
  end
end
