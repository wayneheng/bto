class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :index
      t.string :title
      t.integer :flat_type
      t.integer :version
      t.references :launch, index: true

      t.timestamps
    end
  end
end
