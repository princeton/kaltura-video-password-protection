class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :entry_id
      t.string :uiconf_id
      t.string :password_hash
      t.string :password_salt

      t.timestamps
    end
  end
end
