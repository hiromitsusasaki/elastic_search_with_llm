# frozen_string_literal: true

require 'bundler/setup'
require 'openai'
require 'json'

client = OpenAI::Client.new(
  access_token: ENV['OPENAI_AUTH_KEY'],
  uri_base: 'https://oai.hconeai.com/',
  request_timeout: 240
)

prompt = {
  role: 'user',
  content: 'ブックマークを検索してRubyのrspecについて教えてください'
}

response1 = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo-0613',
    messages: [prompt],
    function_call: 'auto',
    functions: [{
      name: 'search_articles_from_bookmarks',
      description: 'Retrieve articles from bookmarks by searching keywords',
      parameters: {
        type: 'object',
        properties: {
          keywords: {
            type: 'string',
            description: 'Keywords to search articles devided by space'
          }
        },
        required: ['keywords']
      }
    }]
  }
)

p response1
