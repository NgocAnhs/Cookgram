class AddTrustedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trusted, :boolean, default: false
  end
end
