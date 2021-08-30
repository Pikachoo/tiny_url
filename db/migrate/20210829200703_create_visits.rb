class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.integer :ipv4, limit: 8
      t.binary  :ipv6, limit: 16
      t.integer :count, default: 1
      t.belongs_to :url
      t.timestamps
    end
  end
end
