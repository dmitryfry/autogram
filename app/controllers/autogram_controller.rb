class AutogramController < ApplicationController

  def start
  end

  def run
  end

  private

  def run_params
    params.permit(:count)
  end
end
