class CreateTownProjects < ActiveRecord::Migration
  def change
    create_table :town_projects do |t|
      t.string :town_name

      t.timestamps
    end
  end
end
