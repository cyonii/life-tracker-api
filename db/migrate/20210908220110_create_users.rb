class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.string :email, null: false, index: true
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
