class Api::V1::MasterApiController < ApplicationController
  include ::ActionView::Layouts
  
  layout "api/v1/application"

  def xhr_options_request
  	head :ok
  end
end