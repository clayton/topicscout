module CollectionsHelper
  def collection_tab_nav_link(text, path, active)
    css_classes = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    css_classes = 'border-purple-500 text-purple-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm' if active
    link_to(text, path, class: css_classes)
  end
end
