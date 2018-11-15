class ApplicationController < ActionController::API
  def health
    database_status = ActiveRecord::Base.connection.execute("SELECT 1 FROM events")
    commit_id = File.read(File.expand_path("../../../commit_id.txt", __FILE__))
    render json: {status: "ok", version: VERSION, database_status: "connected", commit_id: commit_id}.to_json
  end
end
