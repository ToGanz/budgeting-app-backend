class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.string :title, null: false

      t.timestamps
    end

    add_index :plans, :title, unique: true
  end
end
