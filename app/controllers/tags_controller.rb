class TagsController < ApplicationController
  def index
    @tags = content_repository.tags.sort_by { |tag| [ -tag.post_count, tag.slug ] }
  end

  def show
    @tag = content_repository.find_tag!(params[:slug])
    @posts = @tag.posts
  end
end
