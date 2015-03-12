class ChangeUserColumnsToFitDevise < ActiveRecord::Migration
	def change
		change_table :users do |t|
			## Database authenticatable
			t.string :encrypted_password, null: false, default: ""
			
			## Recoverable
			t.rename :reset_token, :reset_password_token
			t.rename :reset_date, :reset_password_sent_at
			
			## Rememberable
			t.datetime :remember_created_at
			
			## Trackable
			t.integer  :sign_in_count, default: 0, null: false
			t.datetime :current_sign_in_at
			t.rename   :last_login, :last_sign_in_at
			t.inet     :current_sign_in_ip
			t.inet     :last_sign_in_ip
			
			## Confirmable
			t.string   :confirmation_token
			t.datetime :confirmed_at
			t.datetime :confirmation_sent_at
			t.string   :unconfirmed_email # Only if using reconfirmable
		end
	end
end
