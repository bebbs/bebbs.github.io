class FeedsController < ApplicationController
  layout false

  def show
    @posts = content_repository.posts
  end
end
