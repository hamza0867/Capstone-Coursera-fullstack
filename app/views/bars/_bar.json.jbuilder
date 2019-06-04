json.extract! bar, :name, :created_at, :updated_at
json.id bar.id.to_s
json.url bar_url(bar, format: :json)
