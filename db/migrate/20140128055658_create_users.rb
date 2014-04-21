class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

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

      # Using Postgres?
      # t.hstore :data, :default => {}

      t.timestamps

    end
    add_index :users, :email
  end
end
