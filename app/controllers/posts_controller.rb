class PostsController < ApplicationController
  def show
    @post = content_repository.find_post!(params[:slug])
  end
end
