class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.integer :user_id
      t.integer :integration_id
      t.string :invoke_name
      t.string :token

      t.timestamps
    end
  end
end
