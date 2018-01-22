class CreateUsertrackers < ActiveRecord::Migration[5.1]
  def change
    create_table :usertrackers do |t|
      t.integer :user
      t.string :uhashid

      t.timestamps
    end
  end
end
