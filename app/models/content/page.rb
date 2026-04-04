module Content
  class Page < Entry
    def path
      "/#{slug}"
    end
  end
end
