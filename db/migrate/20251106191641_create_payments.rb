class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.integer :amount_cents
      t.datetime :processed_at

      t.timestamps
    end
  end
end
