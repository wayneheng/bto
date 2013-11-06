json.array!(@town_projects) do |town_project|
  json.extract! town_project, :town_name
  json.url town_project_url(town_project, format: :json)
end
