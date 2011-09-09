class AddSmsTrack < ActiveRecord::Migration
  def self.up
    add_column :tasks, :sms_sent, :integer, :default=>0
    add_column :tasks, :gcal_id, :string, :default=>nil
  end

  def self.down
    remove_column :tasks, :sms_sent
    remove_column :tasks, :gcal_id
  end
end
