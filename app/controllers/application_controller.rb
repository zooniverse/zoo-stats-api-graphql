class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic

  def health
    render json: {
      status: 'ok',
      database_status: db_connection_status,
      commit_id: ENV['REVISION']
    }.to_json
  end

  private

  def db_connection_status
    if ActiveRecord::Base.connected?
      "connected"
    else
      "not-connected"
    end
  end
end
