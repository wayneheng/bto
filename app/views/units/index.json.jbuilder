json.array!(@units) do |unit|
  json.extract! unit, :index, :title, :blk, :price, :project_id
  json.url unit_url(unit, format: :json)
end
