class AddSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :application_settings do |t|
      t.string :name
      t.integer :value
    end

    add_index :urls, :name, unique: true
  end
end
