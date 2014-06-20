class Video < ActiveRecord::Base

  validates_presence_of :entry_id
  # Make sure that the entry_id contains an underscore
  validates_format_of :entry_id, :with => /.+_.+/, :message => "entry_id should contain an underscore character"

  validates_presence_of :uiconf_id

  validates_presence_of :password_hash
  validates_length_of :password_hash, :minimum => 8

  validates_presence_of :password_salt
end
