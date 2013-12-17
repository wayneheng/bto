class AddMapToBlock < ActiveRecord::Migration
  def change
    add_column :blks, :mapPath, :string
  end
end
