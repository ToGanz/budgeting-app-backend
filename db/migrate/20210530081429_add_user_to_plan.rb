class AddUserToPlan < ActiveRecord::Migration[6.1]
  def change
    add_reference :plans, :user, foreign_key: true, null: false
  end
end
