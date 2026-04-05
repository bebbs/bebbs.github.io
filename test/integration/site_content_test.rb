require "test_helper"

class SiteContentTest < ActionDispatch::IntegrationTest
  test "homepage renders published posts and tags" do
    get root_path

    assert_response :success
    assert_select "script[type='importmap']"
    assert_select "script[type='module']"
    assert_select "meta[name='turbo-prefetch'][content='false']", false
    assert_select "link[rel='alternate'][type='application/rss+xml'][href='/feed.xml']"
    assert_select "a[href='/tags']", text: "Tags"
    assert_select "a[href='/feed.xml']", text: "RSS"
    assert_select "h2", text: "Starting With Rails and Markdown"
    assert_select "a[href='/tags/ai-engineering']", text: "#ai-engineering"
  end

  test "post pages render markdown content" do
    get post_path("starting-with-rails-and-markdown")

    assert_response :success
    assert_select "h1", text: "Starting With Rails and Markdown"
    assert_select "p", text: /Each post lives in the repository/
  end

  test "page routes render top-level pages" do
    get page_path("about")

    assert_response :success
    assert_select "h1", text: "About"
    assert_select "p", text: /actual content lives in markdown files/
  end

  test "tag pages render matching posts" do
    get tag_path("ai-engineering")

    assert_response :success
    assert_select "h1", text: "#ai-engineering"
    assert_select "a[href='/posts/starting-with-rails-and-markdown']", text: "Starting With Rails and Markdown"
  end

  test "tags index renders the tag cloud" do
    get tags_path

    assert_response :success
    assert_select "p.eyebrow", text: "Tags"
    assert_select "a[href='/tags/ai-engineering']", text: "ai-engineering"
    assert_select ".tag-cloud-count", text: "1"
  end

  test "rss feed renders published posts" do
    get feed_path(format: :xml)

    assert_response :success
    assert_equal "application/xml; charset=utf-8", response.media_type ? "#{response.media_type}; charset=#{response.charset}" : response.content_type
    assert_includes response.body, "<rss version=\"2.0\""
    assert_includes response.body, "<title>Josh Bebbington</title>"
    assert_includes response.body, "<link>https://joshbebbington.github.io/blog/posts/starting-with-rails-and-markdown</link>"
    assert_includes response.body, "<category>ai-engineering</category>"
  end
end
