module TweetsHelper
  def display_entitites(text)
    formatted = text.gsub(/(#[\S]+)/, "<span class='text-purple-800'>\\1</span>")
    formatted = formatted.gsub(/(https\:\S+)/, "<a href='\\1' class='text-purple-500'>\\1</a>")
    formatted = formatted.gsub(/@([\S]+)/, "<a href='https://twitter.com/\\1' class='text-purple-500'>@\\1</a>")

    formatted.html_safe
  end
end
