json.array!(@games) do |game|
  json.extract! game, :id, :partnership_id, :start, :end
  json.url game_url(game, format: :json)
end
