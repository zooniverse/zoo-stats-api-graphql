class ApplicationController < ActionController::API
  def health
    render json: {status: 'ok', version: VERSION}.to_json
  end
end
