class Launch < ActiveRecord::Base
  has_many :town_projects
  has_many :projects,
  dependent: :destroy
end
