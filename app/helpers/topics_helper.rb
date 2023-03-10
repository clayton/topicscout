module TopicsHelper

  def retweet_svg
    svg = <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path fill-rule="evenodd" d="M15.312 11.424a5.5 5.5 0 01-9.201 2.466l-.312-.311h2.433a.75.75 0 000-1.5H3.989a.75.75 0 00-.75.75v4.242a.75.75 0 001.5 0v-2.43l.31.31a7 7 0 0011.712-3.138.75.75 0 00-1.449-.39zm1.23-3.723a.75.75 0 00.219-.53V2.929a.75.75 0 00-1.5 0V5.36l-.31-.31A7 7 0 003.239 8.188a.75.75 0 101.448.389A5.5 5.5 0 0113.89 6.11l.311.31h-2.432a.75.75 0 000 1.5h4.243a.75.75 0 00.53-.219z" clip-rule="evenodd" />
            </svg>
    SVG
    svg.html_safe
  end

  def impression_svg
    svg = <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path d="M10 12.5a2.5 2.5 0 100-5 2.5 2.5 0 000 5z" />
              <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 010-1.186A10.004 10.004 0 0110 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0110 17c-4.257 0-7.893-2.66-9.336-6.41zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd" />
            </svg>
    SVG
    svg.html_safe
  end

  def score_svg
    svg = <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
      <path d="M15.5 2A1.5 1.5 0 0014 3.5v13a1.5 1.5 0 001.5 1.5h1a1.5 1.5 0 001.5-1.5v-13A1.5 1.5 0 0016.5 2h-1zM9.5 6A1.5 1.5 0 008 7.5v9A1.5 1.5 0 009.5 18h1a1.5 1.5 0 001.5-1.5v-9A1.5 1.5 0 0010.5 6h-1zM3.5 10A1.5 1.5 0 002 11.5v5A1.5 1.5 0 003.5 18h1A1.5 1.5 0 006 16.5v-5A1.5 1.5 0 004.5 10h-1z" />
    </svg>
    SVG
    svg.html_safe
  end

  def like_svg
    svg = <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path d="M9.653 16.915l-.005-.003-.019-.01a20.759 20.759 0 01-1.162-.682 22.045 22.045 0 01-2.582-1.9C4.045 12.733 2 10.352 2 7.5a4.5 4.5 0 018-2.828A4.5 4.5 0 0118 7.5c0 2.852-2.044 5.233-3.885 6.82a22.049 22.049 0 01-3.744 2.582l-.019.01-.005.003h-.002a.739.739 0 01-.69.001l-.002-.001z" />
            </svg>
    SVG
    svg.html_safe
  end

  def topic_tab_nav_link(text, path, active)
    css_classes = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    if active
      css_classes = 'border-violet-500 text-violet-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    end
    link_to(text, path, class: css_classes)
  end

  def recent_search_time_in_words(topic)
    return 'some time' unless topic
    return 'some time' unless topic.twitter_search_results.completed.any?

    distance_of_time_in_words_to_now(topic.twitter_search_results.completed&.last&.created_at)
  end

  def hour_options_array
    [
      ['12:00 AM', '0'],
      ['1:00 AM', '1'],
      ['2:00 AM', '2'],
      ['3:00 AM', '3'],
      ['4:00 AM', '4'],
      ['5:00 AM', '5'],
      ['6:00 AM', '6'],
      ['7:00 AM', '7'],
      ['8:00 AM', '8'],
      ['9:00 AM', '9'],
      ['10:00 AM', '10'],
      ['11:00 AM', '11'],
      ['12:00 PM', '12'],
      ['1:00 PM', '13'],
      ['2:00 PM', '14'],
      ['3:00 PM', '15'],
      ['4:00 PM', '16'],
      ['5:00 PM', '17'],
      ['6:00 PM', '18'],
      ['7:00 PM', '19'],
      ['8:00 PM', '20'],
      ['9:00 PM', '21'],
      ['10:00 PM', '22'],
      ['11:00 PM', '23']
    ]
  end
end
