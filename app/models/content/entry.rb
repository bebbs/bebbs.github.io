module Content
  class Entry
    attr_reader :title, :slug, :body_html, :source_path

    def initialize(title:, slug:, body_html:, source_path:)
      @title = title
      @slug = slug
      @body_html = body_html
      @source_path = Pathname(source_path)
    end

    def summary
      @summary ||= begin
        plain_text = ActionView::Base.full_sanitizer.sanitize(body_html).squish
        plain_text.truncate(220, separator: " ")
      end
    end
  end
end
