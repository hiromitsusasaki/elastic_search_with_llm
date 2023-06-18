module GptRequestable
  extend ActiveSupport::Concern

  class_methods do
    def inject_reference_text_from_url(url)
      agent = Mechanize.new
      page = agent.get(url)
      doc = page.parser
      text_elements = doc.css('p, h1, h2, h3, h4, h5, h6')
      text_elements.map do |element|
        element.text.gsub("/\n", "\n")
      end.join("\n")
    rescue StandardError
      return nil
    end

    def client
      OpenAI::Client.new(
        access_token: ENV['OPENAI_AUTH_KEY'],
        uri_base: 'https://oai.hconeai.com/',
        request_timeout: 240
      )
    end

    def summarize(text)
      p response = self.client.chat(
        parameters: self.parameters_to_summarize_text(text)
      )
      if response['choices'].present?
        response['choices'][0]['message']['content']
      else
        nil
      end
    end

    def answer(query, references)
      p response = self.client.chat(
        parameters: self.parameters_to_answer_question(query, references)
      )
      if response['choices'].present?
        response['choices'][0]['message']['content']
      else
        "回答が得られませんでした"
      end
    end

    def parameters_to_use_function_search_articles_from_bookmarks(query)
      system_to_use_function = {
        role: 'system',
        content: "You can search the database of bookmarks using the given function. Be sure to search the bookmarks for questions from the user."
      }
      user = {
        role: 'user',
        content: "Search with the search_articles_from_bookmarks Function for the following questions.\n\n#question:\n#{query}"
      }
      {
        model: 'gpt-3.5-turbo-0613',
        messages: [system_to_use_function, user],
        function_call: 'auto',
        functions: [search_articles_from_bookmarks]
      }
    end

    def parameters_to_use_function_search_pages_from_google(query)
      system_to_use_function = {
        role: 'system',
        content: "You can search at google using the given function. Be sure to search at google for questions from the user."
      }
      user = {
        role: 'user',
        content: "Search with the search_articles_from_bookmarks Function for the following questions.\n\n#question:\n#{query}"
      }
      {
        model: 'gpt-3.5-turbo-0613',
        messages: [system_to_use_function, user],
        function_call: 'auto',
        functions: [search_pages_from_google]
      }
    end

    def parameters_to_summarize_text(text)
      system_content = "You are the one who knows everything in the world and can summarize any sentence without compromising its meaning."
      system_to_answer_question = {
        role: 'system',
        content: system_content
      }
      user = {
        role: 'user',
        content: "Please summarize the following text in about 1000 words, keeping the implication intact as much as possible.\n\n#{text}"
      }
      {
        model: 'gpt-3.5-turbo-0613',
        messages: [system_to_answer_question, user],
        function_call: 'none',
        functions: [search_articles_from_bookmarks]
      }
    end

    def parameters_to_answer_question(query, references)
      if references.blank?
        system_content = "You can answer users' questions in Japanese to the best of your knowledge."
      else
        system_content = <<-EOS
          You can answer users' questions in Japanese to the best of your knowledge.
          Please refer to the following information if necessary.
          ------
          #{references.join("\n")}
        EOS
      end

      system_to_answer_question = {
        role: 'system',
        content: system_content
      }
      user = {
        role: 'user',
        content: query
      }
      {
        model: 'gpt-3.5-turbo-0613',
        messages: [system_to_answer_question, user],
        function_call: 'none',
        functions: [search_articles_from_bookmarks]
      }
    end

    def search_articles_from_bookmarks
      {
        name: 'search_articles_from_bookmarks',
        description: 'Retrieve articles from bookmarks by searching keywords. keywords are simple words and devided by space.',
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
      }
    end

    def search_pages_from_google
      {
        name: 'search_pages_from_google',
        description: 'Retrieve pages from Google search results by searching keywords. keywords are simple words and devided by space.',
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
      }
    end
  end
end
