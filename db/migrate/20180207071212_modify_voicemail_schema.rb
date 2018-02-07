class ModifyVoicemailSchema < ActiveRecord::Migration[5.1]
  def change
    drop_table :calls_voicemails
    add_foreign_key :voicemails, :calls
  end
end
