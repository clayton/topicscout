module TweetsHelper
  def display_entitites(text)
    formatted = text.gsub(/(#[\w]+)/, "<span class='text-purple-800'>\\1</span>")
    formatted = formatted.gsub(/(https\:\S+)/, "<a href='\\1' target='_blank' class='text-purple-500'>\\1</a>")
    formatted = formatted.gsub(/@([\w]+)/, "<a href='https://twitter.com/\\1' target='_blank' class='text-purple-500'>@\\1</a>")
    formatted = formatted.gsub(/\n/, '<br>')
    formatted.html_safe
  end

  def markdown_entities(text)
    formatted = text.gsub(/(https\:\S+)/, "[\\1](\\1)")
    formatted = formatted.gsub(/(#[\w]+)/, "[\\1](https://twitter.com/hashtag/\\1)")
    formatted = formatted.gsub(/@([\w]+)/, "[\\1](https://twitter.com/\\1)")

    formatted.html_safe
  end
end
