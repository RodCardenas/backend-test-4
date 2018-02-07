class CreateJoinTableCallVoicemail < ActiveRecord::Migration[5.1]
  def change
    create_join_table :calls, :voicemails do |t|
      t.index [:call_id, :voicemail_id]
      t.index [:voicemail_id, :call_id]
    end
  end
end
