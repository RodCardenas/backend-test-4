class CreateTableVoicemails < ActiveRecord::Migration[5.1]
  def change
    create_table :voicemails do |t|
      t.text "link", null: false
    end
  end
end
