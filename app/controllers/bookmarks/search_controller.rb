class Bookmarks::SearchController < ApplicationController

  def index
    if params[:query].blank?
      @bookmarks = []
    else
      @bookmarks = Bookmark.es_search(params[:query]).records
      @query = params[:query]
    end
  end

end
