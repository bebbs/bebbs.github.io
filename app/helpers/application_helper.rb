module ApplicationHelper
  def page_title(title = nil)
    [ title, site_title ].compact.join(" · ")
  end

  def site_title
    Rails.configuration.x.site.title
  end

  def site_tagline
    Rails.configuration.x.site.tagline
  end

  def format_publish_date(date)
    date.strftime("%-d %B %Y")
  end

  def nav_link_classes(path)
    base = "nav-link"
    current_page?(path) ? "#{base} nav-link-current" : base
  end

  def site_url
    Rails.configuration.x.site.url.presence
  end

  def absolute_url_for(path)
    return path if path.to_s.match?(%r{\Ahttps?://})
    return path if site_url.blank?

    base_url = site_url.to_s.chomp("/")
    base_path = URI.parse(base_url).path.presence
    normalized_path = path.to_s

    if base_path.present? && normalized_path.start_with?(base_path)
      normalized_path = normalized_path.delete_prefix(base_path)
      normalized_path = "/#{normalized_path}" unless normalized_path.start_with?("/")
    end

    "#{base_url}#{normalized_path}"
  end

  def tag_cloud_link_classes(tag, tags)
    max_count = tags.map(&:post_count).max.to_i

    scale_class =
      case [ tag.post_count, max_count ]
      in [count, max] if max <= 1 || count >= max
        "tag-cloud-link-lg"
      in [count, max] if count >= (max * 0.66)
        "tag-cloud-link-md"
      in [count, max] if count >= (max * 0.4)
        "tag-cloud-link-sm"
      else
        "tag-cloud-link-sm"
      end

    [ "tag-cloud-link", scale_class ].join(" ")
  end
end
