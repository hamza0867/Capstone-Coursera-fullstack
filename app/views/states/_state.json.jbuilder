json.id state.id.to_s
json.extract! state, :name, :created_at, :updated_at
json.url state_url(state, format: :json)
