class ApplicationController < ActionController::API
  def health
    database_status = ActiveRecord::Base.connection.execute("SELECT 1 FROM events")
    render json: {status: "ok", version: VERSION, database_status: "connected", commit_id: fetch_commit_id}.to_json
  end

  private
  def fetch_commit_id
    Rails.cache.fetch("commit_id", expires_in: 10.days) do
      File.read(File.expand_path("../../../commit_id.txt", __FILE__))
    end
  end
end
