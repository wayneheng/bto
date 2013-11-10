class AddIsTakenToUnit < ActiveRecord::Migration
  def change
    add_column :units, :is_taken, :boolean
  end
end
