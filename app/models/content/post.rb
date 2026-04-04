module Content
  class Post < Entry
    attr_reader :published_on, :tags

    def initialize(title:, slug:, published_on:, tags:, body_html:, source_path:)
      super(title:, slug:, body_html:, source_path:)
      @published_on = published_on
      @tags = tags
    end

    def path
      "/posts/#{slug}"
    end
  end
end
