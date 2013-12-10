class CreateBlks < ActiveRecord::Migration
  def change
    create_table :blks do |t|
      t.string :title
      t.string :url
      t.references :project, index: true
      t.string :contract
      t.string :neighbourhood

      t.timestamps
    end
  end
end
