class HomeController < ApplicationController
  def index
    @posts = content_repository.posts
  end
end
