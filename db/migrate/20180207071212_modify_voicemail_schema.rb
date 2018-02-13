class ModifyVoicemailSchema < ActiveRecord::Migration[5.1]
  def change
    drop_table :calls_voicemails
  end
end
