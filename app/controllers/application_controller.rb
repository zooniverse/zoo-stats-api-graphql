class ApplicationController < ActionController::API
  def health
    database_status = ActiveRecord::Base.connection.execute("SELECT 1 FROM events")
    render json: {status: "ok", version: VERSION, database_status: database_status}.to_json
  end
end
