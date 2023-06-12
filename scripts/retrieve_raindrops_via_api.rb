require 'net/http'
require 'json'

# Raindrop.io APIキー
api_key = ENV['RAINDROP_API_KEY']

# ユーザーのブックマークデータを取得するエンドポイント
endpoint = 'https://api.raindrop.io/rest/v1/raindrops/35148982'

# APIリクエストを作成
uri = URI(endpoint)
params = { perpage: 50, page: 0 }
uri.query = URI.encode_www_form(params)
headers = { 'Authorization' => "Bearer #{api_key}" }

# APIリクエストを送信してレスポンスを取得
response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  http.get(uri.request_uri, headers)
end

# レスポンスをJSONとして解析
data = JSON.parse(response.body)

# ブックマークデータを表示
data['items'].each do |bookmark|
  puts "ID: #{bookmark['_id']}"
  puts "Title: #{bookmark['title']}"
  puts "URL: #{bookmark['link']}"
  puts "Description: #{bookmark['excerpt']}"
  puts "CreatedAt: #{bookmark['created']}"
  puts "UpdatedAt: #{bookmark['lastUpdate']}"
  puts "-----"
end
