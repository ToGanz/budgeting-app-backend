class AddCategpryToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :category, foreign_key: true, null: false
  end
end
