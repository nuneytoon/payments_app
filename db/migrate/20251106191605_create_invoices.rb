class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :total_cents
      t.integer :balance_cents
      t.string :status

      t.timestamps
    end
  end
end
