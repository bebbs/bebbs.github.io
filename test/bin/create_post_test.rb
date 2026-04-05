require "test_helper"
require "open3"
require "tmpdir"

class CreatePostTest < ActiveSupport::TestCase
  test "creates a post skeleton from the slug" do
    Dir.mktmpdir do |dir|
      content_root = File.join(dir, "content")
      output, status = Open3.capture2e(
        { "CONTENT_ROOT" => content_root },
        Rails.root.join("bin/create-post").to_s,
        "my-new-post"
      )

      assert status.success?, output

      path = File.join(content_root, "posts/my-new-post.md")

      assert_equal <<~MARKDOWN, File.read(path)
        ---
        title: My new post
        slug: my-new-post
        publish_date: #{Date.today.iso8601}
        tags: []
        ---

        Start with a short opening paragraph that tells the reader what this post is about.

        ## Main idea

        Add the core of the post here.

        ## Wrap up

        Close with the takeaway or next step.
      MARKDOWN

      assert_match(%r{Created .*my-new-post\.md}, output)
    end
  end

  test "rejects an invalid slug" do
    Dir.mktmpdir do |dir|
      output, status = Open3.capture2e(
        { "CONTENT_ROOT" => File.join(dir, "content") },
        Rails.root.join("bin/create-post").to_s,
        "Not Valid"
      )

      assert_not status.success?
      assert_match(/Invalid slug/, output)
    end
  end
end
