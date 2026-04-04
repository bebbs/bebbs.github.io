class PagesController < ApplicationController
  def show
    @page = content_repository.find_page!(params[:slug])
  end
end
