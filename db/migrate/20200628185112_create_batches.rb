class CreateBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.string :reference
      t.string :purchase_channel

      t.timestamps
    end

    add_index :batches, [:reference], :unique => true
  end
end
