class CreateMoriUsers < ActiveRecord::Migration
  def change
    create_table :mori_users do |t|

      t.string :email
      t.text :password

      # Invite Related
      t.string :invitation_token
      t.datetime :invitation_sent

      # Password Reset
      t.string :password_reset_token
      t.datetime :password_reset_sent

      # Confirmable
      t.boolean :confirmed
      t.string :confirmation_token
      t.datetime :confirmation_sent

      # Group Relation
      t.integer :group_id

      # Application specific attributes
      t.hstore :data, :default => {}

      t.timestamps

    end
    add_index :mori_users, :email
    add_index :mori_users, :group_id
  end
end
