class AddStatusToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :status, :text
  end
end
