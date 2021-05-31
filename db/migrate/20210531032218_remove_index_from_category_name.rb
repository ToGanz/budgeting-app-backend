class RemoveIndexFromCategoryName < ActiveRecord::Migration[6.1]
  def change
    remove_index :categories, name: "index_categories_on_name"
  end
end
