module ApplicationHelper
  include Pagy::Frontend

  def mobile_navigation_link_class(path)
    if request.path.include?(path)
      'bg-violet-800 text-white group flex items-center px-2 py-2 text-base font-medium rounded-md'
    else
      'text-white hover:bg-violet-600 hover:bg-opacity-75 group flex items-center px-2 py-2 text-base font-medium rounded-md'
    end
  end

  def desktop_navigation_link_class(path)
    if request.path.include?(path)
      'bg-violet-800 text-white group flex items-center px-2 py-2 text-sm font-medium rounded-md'
    else
      'text-white hover:bg-violet-600 hover:bg-opacity-75 group flex items-center px-2 py-2 text-sm font-medium rounded-md'
    end
  end
end
