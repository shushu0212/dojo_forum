class CreateAudiences < ActiveRecord::Migration[5.1]
  def change
    create_table :audiences do |t|
      t.string :name
      t.timestamps
    end
    add_column :topics, :audience_id, :integer, default: 1
  end
end
