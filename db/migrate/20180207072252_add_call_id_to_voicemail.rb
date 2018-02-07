class AddCallIdToVoicemail < ActiveRecord::Migration[5.1]
  def change
    add_column :voicemails, :call_id, :int, index: true
  end
end
