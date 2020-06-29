class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :reference
      t.string :purchase_channel
      t.string :client_name
      t.text :address
      t.string :delivery_service
      t.decimal :total_value
      t.json :line_items, array: true, default: []
      t.string :status
      t.references :batch

      t.timestamps
    end

    add_index :orders, [:reference], :unique => true
  end
end
