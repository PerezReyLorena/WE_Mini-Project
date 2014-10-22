json.array!(@partnerships) do |partnership|
  json.extract! partnership, :id, :user1_id, :user2_id, :game_id
  json.url partnership_url(partnership, format: :json)
end
