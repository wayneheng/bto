class Project < ActiveRecord::Base
  belongs_to :launch
  has_many :units
  
  def block_list
    return self.blocks.split(',')
  end
  
  def units_json
    
  end
  
end
