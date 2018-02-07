class RemoveDetailsFromCalls < ActiveRecord::Migration[5.1]
  def change
    remove_column :calls, :voicemail_link, :string
  end
end
