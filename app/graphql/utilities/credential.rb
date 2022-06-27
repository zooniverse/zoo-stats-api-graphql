require 'panoptes-client'

# Wrapper around the authentication token given by API consumers.
class Credential
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def current_user_id
    jwt_payload['id']
  end

  def current_admin_status
    jwt_payload['admin']
  end

  def ok?
    logged_in? && !expired?
  end

  def logged_in?
    return false unless jwt_payload.present?
    jwt_payload['login'].present?
  rescue JWT::ExpiredSignature, JWT::VerificationError
    false
  end

  def expired?
    expires_at < Time.zone.now
  end

  private

  def jwt_payload
    @jwt_payload ||= token ? client.current_user : {}
  end

  def client
    @client ||= Panoptes::Client.new(env: panoptes_client_env, auth: { token: token })
  end

  def panoptes_client_env
    ENV["RAILS_ENV"]
  end

  def expires_at
    @expires_at ||= begin
                      payload, _ = JWT.decode token, client.jwt_signing_public_key, algorithm: 'RS512'
                      Time.at(payload.fetch('exp'))
                    end
  end
end
