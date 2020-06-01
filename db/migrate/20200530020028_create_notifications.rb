class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :actor_id, null: false
      t.boolean :read, default: false
      t.string :action
      t.integer :notifiable_id
      t.string :notifiable_type

      t.timestamps
    end
  end
end
