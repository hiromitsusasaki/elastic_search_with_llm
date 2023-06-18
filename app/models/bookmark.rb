# == Schema Information
#
# Table name: bookmarks
#
#  id                   :bigint           not null, primary key
#  created_in_source_at :datetime
#  description          :text(65535)
#  identifier_in_source :integer
#  title                :text(65535)
#  updated_in_source_at :datetime
#  url                  :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Bookmark < ApplicationRecord
  include BookmarkSearchable
  include GptRequestable

  class << self
    def seach_articles(keywords, limit)
      es_search(keywords).limit(limit)
    end

    def inquiry_by_natural_language(query)
      p function_calling_response = self.client.chat(
        parameters: self.parameters_to_use_function_search_articles_from_bookmarks(query)
      )

      content = function_calling_response['choices'][0]['message']['content']
      function_call = function_calling_response['choices'][0]['message']['function_call']

      if content
        bookmarks = []
        answer = content
      else
        p keywords = JSON.parse(function_call["arguments"])["keywords"]
        bookmarks = self.es_search(keywords).records.limit(5)

        references = []

        bookmarks.first(2).each do |bookmark|
          if bookmark.url.present?
            text = self.inject_reference_text_from_url(bookmark.url)
            next if text.blank?
            reference = self.summarize(text)
            references << reference if reference.present?
          end
        end

        answer = self.answer(query, references)
      end
      return keywords, answer, bookmarks
    end
  end
end
