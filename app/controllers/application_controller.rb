class ApplicationController < ActionController::Base
  helper_method :content_repository, :site_pages

  rescue_from Content::NotFound, with: :raise_not_found

  private

  def content_repository
    @content_repository ||= Content::Repository.new
  end

  def site_pages
    content_repository.pages
  end

  def raise_not_found
    raise ActionController::RoutingError, "Not Found"
  end
end
