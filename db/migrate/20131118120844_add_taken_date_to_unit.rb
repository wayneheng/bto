class AddTakenDateToUnit < ActiveRecord::Migration
  def change
    add_column :units, :taken_date, :datetime    
  end
end
