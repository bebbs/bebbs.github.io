class BadgeComponent < ViewComponent::Base
  BADGES = [
    {
      slug: :carwow,
      background_colour: "bg-carwow",
      text_colour: "text-black-200",
      text: "Carwow",
      url: "https://www.carwow.co.uk"
    },
    {
      slug: :github,
      background_colour: "bg-slate-800",
      text_colour: "text-white",
      text: "GitHub",
      url: "https://github.com/bebbs"
    }
  ].freeze

  def initialize(badge)
    @badge = BADGES.find { |b| b[:slug] == badge }
  end

  def render?
    @badge.present?
  end

  def url
    @badge[:url]
  end

  def text
    @badge[:text]
  end

  def css_classes
    [ @badge[:background_colour], @badge[:text_colour], "font-bold", "px-2", "py-1" ]
  end
end
