class Bookmarks::SearchController < ApplicationController

  def index
    @query = query
    @bookmarks = if @query.present?
      Bookmark.es_search(@query).page(page || 1).per(10).records
    else
      Bookmark.page(page || 1).per(10)
    end
  end

  private

  def query
    params[:query]
  end

  def page
    params[:page]
  end
end
