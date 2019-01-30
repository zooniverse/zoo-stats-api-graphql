class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic

  def health
    render json: {
      status: "ok",
      version: VERSION,
      database_status: db_connection_status,
      commit_id: fetch_commit_id
    }.to_json
  end

  private

  def fetch_commit_id
    commit_id = Rails.cache.fetch("commit_id", expires_in: 10.days) do
      File.read(File.expand_path("../../../commit_id.txt", __FILE__))
    end
    commit_id.strip
  end

  def db_connection_status
    if ActiveRecord::Base.connected?
      "connected"
    else
      "not connected"
    end
  end
end
