class RemoveUniqueNameIndexFromPlans < ActiveRecord::Migration[6.1]
  def change
    remove_index :plans, name: "index_plans_on_title"
  end
end
