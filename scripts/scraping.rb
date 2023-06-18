require 'bundler/setup'
require 'mechanize'
require 'reverse_markdown'

agent = Mechanize.new
page = agent.get('https://qiita.com/tatsurou313/items/c923338d2e3c07dfd9ee')

# html body to markdown
# doc = page.parser
# text_elements = doc.css('p, div, h1, h2, h3, h4, h5, h6')
# text_content = text_elements.map do |element|
#   ReverseMarkdown.convert(input: element.to_s, unknown_tags: :bypass)
# end.join("\n\n")
# puts text_content

# html body to text
doc = page.parser
text_elements = doc.css('p, h1, h2, h3, h4, h5, h6 code pre')
text_content = text_elements.map(&:text).join("\n")
puts text_content
