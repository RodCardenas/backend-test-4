class AddConstraintsToCalls < ActiveRecord::Migration[5.1]
  def change
    change_column :calls, :to, :text, null: false
    change_column :calls, :from, :text, null: false
  end
end
