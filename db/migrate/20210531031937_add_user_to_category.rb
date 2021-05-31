class AddUserToCategory < ActiveRecord::Migration[6.1]
  def change
    add_reference :categories, :user, foreign_key: true, null: false
  end
end