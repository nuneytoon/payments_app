class CreateRefunds < ActiveRecord::Migration[8.1]
  def change
    create_table :refunds do |t|
      t.references :payment, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :reason

      t.timestamps
    end
  end
end
