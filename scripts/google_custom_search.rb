# frozen_string_literal: true

require 'bundler/setup'
require 'google/apis/customsearch_v1'

searcher = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
cx = ENV.fetch('GOOGLE_CSE_ID')
searcher.key = ENV.fetch('GOOGLE_API_KEY')

results = searcher.list_cses(cx: cx, q: 'ruby rails')
results.items.first(3).each do |item|
  p item.title
  p item.snippet
  p item.link
end

