require "test_helper"

class SiteContentTest < ActionDispatch::IntegrationTest
  test "homepage renders published posts and tags" do
    get root_path

    assert_response :success
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
end
