# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :country_code, default: ""
      t.string :phone_number, default: ""
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :verification_code
      t.datetime :verification_code_sent_at

      # Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Confirmable
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using reconfirmable
      t.string :unconfirmed_country_code
      t.string :unconfirmed_phone_number

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Profile
      t.string :name
      t.integer :status
      t.integer :profile_status
      t.integer :gender
      t.integer :is_verified
      t.boolean :enable_notifications, default: 0

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, [:country_code, :phone_number], unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, [:email, :status], unique: true, where: "status = 0"
  end
end
