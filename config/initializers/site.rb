Rails.application.configure do
  config.x.site.title = "Josh Bebbington"
  config.x.site.tagline = "Writing about software, AI systems, and the craft around them."
  config.x.site.url = ENV.fetch("SITE_URL", "https://joshbebbington.github.io/blog")
end
