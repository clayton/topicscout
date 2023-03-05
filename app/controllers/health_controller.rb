class HealthController < ApplicationController
  def show
    render plain: 'OK', status: 200
  end
end
