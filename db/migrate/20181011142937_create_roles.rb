class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    remove_column :users, :role
    add_column :users, :role_id, :integer, default: 2
  end
end
