class TagsController < ApplicationController
  def show
    @tag = content_repository.find_tag!(params[:slug])
    @posts = @tag.posts
  end
end
