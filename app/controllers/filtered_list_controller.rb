class FilteredListController < ApplicationController
  before_action :set_default_sort
  before_action :set_default_filter
  before_action :determine_sort
  before_action :determine_time_filter
  before_action :determine_visibility_filter

  def set_default_sort
    @sort = filter_params.fetch(:sort, 'score')
  end

  def set_default_filter
    @time_filter = filter_params.fetch(:time_filter, 'all')
  end

  def determine_sort
    return @sort = 'score' unless params[:sort].in? %w[score newest]

    @sort = filter_params.fetch(:sort, 'score')
  end

  def determine_time_filter
    return @time_filter = 'all' unless params[:time_filter].in? %w[all hour day yesterday week]

    @time_filter = filter_params.fetch(:time_filter, 'all')
  end

  def determine_visibility_filter
    return @visibility_filter = nil unless params[:visibility_filter].in? %w[relevant all]

    @visibility_filter = filter_params.fetch(:visibility_filter, 'relevant')
  end

  def filter_params
    params.permit(:page, :sort, :time_filter, :visibility_filter, :topic_id)
  end
end
