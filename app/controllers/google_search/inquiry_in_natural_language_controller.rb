class GoogleSearch::InquiryInNaturalLanguageController < ApplicationController
  def index
    if params[:query]
      @query = params[:query]
      @keywords, @answer, @pages = GoogleSearch.inquiry_by_natural_language(@query)
    end
  end
end
