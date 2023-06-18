module Bookmarks
  class InquiryInNaturalLanguageController < ApplicationController
    def index
      if params[:query]
        @query = params[:query]
        @keywords, @answer, @bookmarks = Bookmark.inquiry_by_natural_language(@query)
      end
    end
  end
end
