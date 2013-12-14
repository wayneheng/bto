class AddTownProjectToProject < ActiveRecord::Migration
  def change
    add_column :projects, :town_project_id, :integer
  end
end
