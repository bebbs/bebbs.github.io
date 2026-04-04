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
end
