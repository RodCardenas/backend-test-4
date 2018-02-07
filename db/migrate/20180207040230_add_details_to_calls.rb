class AddDetailsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :from, :text
    add_column :calls, :to, :text
    add_column :calls, :voicemail_link, :text
  end
end
