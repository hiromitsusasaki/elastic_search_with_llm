namespace :bulk_insert_bookmarks_from_raindrops_via_api do
  desc "raindrop.ioからブックマークを取得し、Bookmarkとして保存する"
  task run: :environment do
    api_key = ENV['RAINDROP_API_KEY']

    # ユーザーのブックマークデータを取得するエンドポイント
    endpoint = ENV['RAINDROP_RETRIEVE_RAINDROPS_ENDPOINT']

    perpage = 50
    page = 0
    is_remaining = true

    while is_remaining do
      # APIリクエストを作成
      uri = URI(endpoint)
      params = { perpage: perpage, page: page }
      uri.query = URI.encode_www_form(params)
      headers = { 'Authorization' => "Bearer #{api_key}" }

      # APIリクエストを送信してレスポンスを取得
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.get(uri.request_uri, headers)
      end

      # レスポンスをJSONとして解析
      data = JSON.parse(response.body)

      count = data['count'].to_i
      remaining_count = count - (perpage * (page + 1))
      is_remaining = remaining_count > 0

      params = []
      data['items'].each do |bookmark|
        params << {
          title: bookmark['title'],
          description: bookmark['excerpt'],
          url: bookmark['link'],
          identifier_in_source: bookmark['_id'].to_i,
          created_in_source_at: Time.zone.parse(bookmark['created']),
          updated_in_source_at: Time.zone.parse(bookmark['lastUpdate'])
        }
      end
      Bookmark.insert_all(params)
      puts "finished page: #{page} remaining_count: #{remaining_count}"
      page += 1
    end
  end
end
