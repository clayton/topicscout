class FilteredListController < ApplicationController
  before_action :set_default_sort
  before_action :set_default_filter
  before_action :determine_sort
  before_action :determine_time_filter

  def set_default_sort
    @sort = params.permit(:score).fetch(:sort, 'score')
  end

  def set_default_filter
    @time_filter = params.permit(:time_filter).fetch(:time_filter, 'all')
  end

  def determine_sort
    return @sort = 'score' unless params[:sort].in? %w[score newest]

    @sort = params.permit(:sort).fetch(:sort, 'score')
  end

  def determine_time_filter
    return @time_filter = 'all' unless params[:time_filter].in? %w[all hour day yesterday week]

    @time_filter = params.permit(:time_filter).fetch(:time_filter, 'all')
  end
end
