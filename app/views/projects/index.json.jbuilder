json.array!(@projects) do |project|
  json.extract! project, :index, :title, :flat_type, :version, :launch_id
  json.url project_url(project, format: :json)
end
