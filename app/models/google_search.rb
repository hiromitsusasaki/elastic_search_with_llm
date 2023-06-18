require 'google/apis/customsearch_v1'

class GoogleSearch
  include BookmarkSearchable
  include GptRequestable

  class << self
    def search(keywords)
      searcher = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
      cx = ENV.fetch('GOOGLE_CSE_ID')
      searcher.key = ENV.fetch('GOOGLE_API_KEY')
      results = searcher.list_cses(cx: cx, q: keywords)
      results.items.first(5).map do |item|
        GoogleSearchResult.new(title: item.title, description: item.snippet, url: item.link)
      end
    end

    def inquiry_by_natural_language(query)
      function_calling_response = self.client.chat(
        parameters: self.parameters_to_use_function_search_pages_from_google(query)
      )

      content = function_calling_response['choices'][0]['message']['content']
      function_call = function_calling_response['choices'][0]['message']['function_call']

      if content
        pages = []
        answer = content
      else
        keywords = JSON.parse(function_call["arguments"])["keywords"]
        pages = self.search(keywords)

        references = []

        pages.first(2).each do |page|
          reference = self.summarize(
            self.inject_reference_text_from_url(page.url)
          )
          references << reference
        end

        answer = self.answer(query, references)
      end
      return keywords, answer, pages
    end
  end
end
