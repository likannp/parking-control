class CreateParkingHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_histories do |t|
      t.references :car, null: false, foreign_key: true
      t.datetime :entry_at
      t.datetime :out_at
      t.boolean :paid

      t.timestamps
    end
  end
end
