require "test_helper"
require "tmpdir"

class Content::RepositoryTest < ActiveSupport::TestCase
  test "rejects duplicate routes" do
    Dir.mktmpdir do |dir|
      write_content(dir, "pages/about.md", <<~MARKDOWN)
        ---
        title: About
        slug: about
        ---

        About page.
      MARKDOWN

      write_content(dir, "pages/about-again.md", <<~MARKDOWN)
        ---
        title: About Again
        slug: about
        ---

        About page again.
      MARKDOWN

      error = assert_raises(Content::InvalidDocument) do
        Content::Repository.new(root: dir).pages
      end

      assert_match(%r{Duplicate route "/about"}, error.message)
    end
  end

  test "rejects reserved page slugs" do
    Dir.mktmpdir do |dir|
      write_content(dir, "pages/posts.md", <<~MARKDOWN)
        ---
        title: Posts
        slug: posts
        ---

        Reserved route.
      MARKDOWN

      error = assert_raises(Content::InvalidDocument) do
        Content::Repository.new(root: dir).pages
      end

      assert_match(/reserved page slug/, error.message)
    end
  end

  private

  def write_content(root, relative_path, contents)
    path = File.join(root, relative_path)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, contents)
  end
end
