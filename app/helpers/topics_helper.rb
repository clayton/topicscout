module TopicsHelper

  def topic_tab_nav_link(text, path, active)
    css_classes = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    css_classes = 'border-violet-500 text-violet-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm' if active
    link_to(text, path, class: css_classes)
  end

  def recent_search_time_in_words(topic)
    return "some time" unless topic
    return "some time" unless topic.twitter_search_results.completed.any?

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
