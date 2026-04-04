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
