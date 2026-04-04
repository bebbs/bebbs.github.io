require "date"
require "kramdown"
require "yaml"

module Content
  class Repository
    FRONT_MATTER_PATTERN = /\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m
    RESERVED_PAGE_SLUGS = %w[posts tags up].freeze
    SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

    def initialize(root: Rails.root.join("content"))
      @root = Pathname(root)
    end

    def posts
      load_data.fetch(:posts)
    end

    def pages
      load_data.fetch(:pages)
    end

    def tags
      load_data.fetch(:tags)
    end

    def find_post!(slug)
      posts.find { |post| post.slug == slug } || raise(NotFound, "Unknown post: #{slug}")
    end

    def find_page!(slug)
      pages.find { |page| page.slug == slug } || raise(NotFound, "Unknown page: #{slug}")
    end

    def find_tag!(slug)
      tags.find { |tag| tag.slug == slug } || raise(NotFound, "Unknown tag: #{slug}")
    end

    private

    def load_data
      @load_data ||= begin
        pages = load_pages
        posts = load_posts
        tags = build_tags(posts)

        validate_unique_paths!(pages + posts + tags)

        {
          pages: pages.sort_by(&:title),
          posts: posts.sort_by { |post| [ -post.published_on.jd, post.title ] },
          tags: tags.sort_by(&:slug)
        }
      end
    end

    def load_pages
      document_paths("pages").map do |path|
        front_matter, body = parse_document(path)
        slug = normalize_slug(fetch_string(front_matter, "slug", path), field: "slug", path:)

        if RESERVED_PAGE_SLUGS.include?(slug)
          raise InvalidDocument, "#{relative_path(path)} uses reserved page slug #{slug.inspect}"
        end

        Page.new(
          title: fetch_string(front_matter, "title", path),
          slug:,
          body_html: render_markdown(body),
          source_path: path
        )
      end
    end

    def load_posts
      document_paths("posts").map do |path|
        front_matter, body = parse_document(path)

        Post.new(
          title: fetch_string(front_matter, "title", path),
          slug: normalize_slug(fetch_string(front_matter, "slug", path), field: "slug", path:),
          published_on: parse_publish_date(front_matter, path),
          tags: normalize_tags(front_matter["tags"], path),
          body_html: render_markdown(body),
          source_path: path
        )
      end
    end

    def build_tags(posts)
      posts
        .flat_map(&:tags)
        .uniq
        .map do |slug|
          Tag.new(
            slug:,
            posts: posts.select { |post| post.tags.include?(slug) }
          )
        end
    end

    def validate_unique_paths!(entries)
      entries.each_with_object({}) do |entry, routes|
        next routes[entry.path] = entry unless routes.key?(entry.path)

        other_entry = routes.fetch(entry.path)
        raise InvalidDocument, "Duplicate route #{entry.path.inspect} in #{describe_entry(other_entry)} and #{describe_entry(entry)}"
      end
    end

    def document_paths(type)
      Dir[@root.join(type, "*.md")].sort
    end

    def parse_document(path)
      contents = File.read(path)
      match = contents.match(FRONT_MATTER_PATTERN)

      unless match
        raise InvalidDocument, "#{relative_path(path)} must start with YAML frontmatter"
      end

      metadata = YAML.safe_load(match[1], permitted_classes: [ Date ], aliases: true)

      unless metadata.is_a?(Hash)
        raise InvalidDocument, "#{relative_path(path)} frontmatter must be a YAML mapping"
      end

      [ metadata, match[2].to_s ]
    rescue Psych::SyntaxError => e
      raise InvalidDocument, "#{relative_path(path)} has invalid YAML frontmatter: #{e.message}"
    end

    def fetch_string(front_matter, key, path)
      value = front_matter[key]

      if value.is_a?(String) && value.present?
        value.strip
      else
        raise InvalidDocument, "#{relative_path(path)} is missing #{key.inspect}"
      end
    end

    def parse_publish_date(front_matter, path)
      value = front_matter["publish_date"] || front_matter["published_on"] || front_matter["date"]

      case value
      when Date
        value
      when String
        Date.iso8601(value)
      else
        raise InvalidDocument, "#{relative_path(path)} is missing \"publish_date\""
      end
    rescue Date::Error
      raise InvalidDocument, "#{relative_path(path)} has an invalid publish date #{value.inspect}"
    end

    def normalize_tags(value, path)
      Array(value).map do |tag|
        normalize_slug(tag, field: "tags", path:)
      end.uniq
    end

    def normalize_slug(value, field:, path:)
      slug = value.to_s.strip.downcase

      unless slug.match?(SLUG_PATTERN)
        raise InvalidDocument, "#{relative_path(path)} has an invalid #{field} value #{value.inspect}"
      end

      slug
    end

    def render_markdown(body)
      Kramdown::Document.new(body, input: "GFM").to_html
    end

    def describe_entry(entry)
      if entry.respond_to?(:source_path)
        relative_path(entry.source_path)
      else
        "generated tag #{entry.slug.inspect}"
      end
    end

    def relative_path(path)
      Pathname(path).relative_path_from(Rails.root).to_s
    end
  end
end
