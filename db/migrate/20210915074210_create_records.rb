class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.float :duration
      t.integer :satisfaction
      t.date :date
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
