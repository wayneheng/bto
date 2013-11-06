class CreateLaunches < ActiveRecord::Migration
  def change
    create_table :launches do |t|
      t.string :title
      t.integer :version
      t.string :imagePath

      t.timestamps
    end
  end
end
