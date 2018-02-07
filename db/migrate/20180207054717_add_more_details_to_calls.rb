class AddMoreDetailsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :duration, :int
    add_column :calls, :direction, :text
  end
end
