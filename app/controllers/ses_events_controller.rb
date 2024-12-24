# frozen_string_literal: true

class SesEventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :transform ]

  # POST /ses_events/transform
  def transform
    event_data = params.to_unsafe_h

    mapped_result = SesEventMapper.call(event_data)

    render json: mapped_result
  end
end
