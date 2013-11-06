json.array!(@launches) do |launch|
  json.extract! launch, :title, :version, :imagePath
  json.url launch_url(launch, format: :json)
end
