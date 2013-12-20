class Project < ActiveRecord::Base
  belongs_to :launch
  belongs_to :town_project
  has_many :units
  has_many :blks, :order => 'created_at ASC'
  
  default_scope order('id ASC')
  
  accepts_nested_attributes_for :blks,
    :allow_destroy => true,
    :reject_if     => :all_blank
  
  def block_list
    return self.blocks.split(',')
  end
  
  def units_json
    
  end
  
end
