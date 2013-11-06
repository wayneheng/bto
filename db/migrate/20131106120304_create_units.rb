class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :index
      t.string :title
      t.string :blk
      t.string :price
      t.references :project, index: true

      t.timestamps
    end
  end
end
