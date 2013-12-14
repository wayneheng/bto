class TownProject < ActiveRecord::Base
  belongs_to :launch
  has_many :projects
end
