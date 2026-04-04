module Content
  class Error < StandardError; end
  class InvalidDocument < Error; end
  class NotFound < Error; end
end
