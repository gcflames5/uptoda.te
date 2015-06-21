json.array!(@versions) do |version|
  json.extract! version, :id, :max, :mid, :min
  json.url version_url(version, format: :json)
end
