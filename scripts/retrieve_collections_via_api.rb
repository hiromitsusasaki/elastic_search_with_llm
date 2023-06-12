require 'net/http'
require 'json'

# Raindrop.io APIキー
api_key = ENV['RAINDROP_API_KEY']

# ユーザーのブックマークデータを取得するエンドポイント
endpoint = ENV['RAINDROP_RETRIEVE_COLLECTIONS_ENDPOINT']

# APIリクエストを作成
uri = URI(endpoint)
headers = { 'Authorization' => "Bearer #{api_key}" }

# APIリクエストを送信してレスポンスを取得
response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  http.get(uri.request_uri, headers)
end

# レスポンスをJSONとして解析
data = JSON.parse(response.body)

# ブックマークデータを表示
data['items'].each do |collection|
  puts "title: #{collection['title']}"
  puts "id: #{collection['_id']}"
  puts "-----"
end
