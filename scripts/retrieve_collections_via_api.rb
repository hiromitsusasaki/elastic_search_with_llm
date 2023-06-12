require 'net/http'
require 'json'

# Raindrop.io APIキー
api_key = '46481302-18da-49b5-8fb8-c67eeb2c5c1e'

# ユーザーのブックマークデータを取得するエンドポイント
endpoint = 'https://api.raindrop.io/rest/v1/collections'

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
