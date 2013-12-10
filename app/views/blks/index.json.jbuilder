json.array!(@blks) do |blk|
  json.extract! blk, :title, :url, :project_id, :contract, :neighbourhood
  json.url blk_url(blk, format: :json)
end
