class AddLaunchIdToTownProjects < ActiveRecord::Migration
  def change
    add_column :town_projects, :launch_id, :integer
  end
end
