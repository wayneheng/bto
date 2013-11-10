class AddUrlAndBlocksToProject < ActiveRecord::Migration
  def change
    add_column :projects, :blocks, :string
    add_column :projects, :scrape_url, :string
  end
end
