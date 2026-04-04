module Content
  class Tag
    attr_reader :slug, :posts

    def initialize(slug:, posts:)
      @slug = slug
      @posts = posts
    end

    def path
      "/tags/#{slug}"
    end

    def post_count
      posts.size
    end
  end
end
