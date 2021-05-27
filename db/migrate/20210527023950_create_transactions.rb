class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.text :description, null: false
      t.boolean :spending, default: false
      t.decimal :amount, default: 0.0

      t.belongs_to :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
