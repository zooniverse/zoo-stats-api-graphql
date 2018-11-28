require_relative '../graphql/utilities/credential'

class GraphqlController < ApplicationController
  attr_reader :credential, :basic_credential
  before_action :setup_and_validate_credential

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user,
      admin: admin_status,
      basic_user: basic_user,
      basic_password: basic_password
    }
    result = ZooStatsSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private
  def current_user
    credential.current_user_id if credential
  end

  def admin_status
    credential.current_admin_status if credential
  end

  def basic_user
    basic_credential[0] if basic_credential
  end

  def basic_password
    basic_credential[1] if basic_credential
  end

  def setup_and_validate_credential
    authorization = request.headers['HTTP_AUTHORIZATION']
    
    if match = /\ABearer (.*)\z/.match(authorization)
      auth = match[1]
      temp = Credential.new(auth)
      @credential = temp if temp.ok?
    end
    if match = /\ABasic (.*)\z/.match(authorization)
      @basic_credential = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
    end
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
  end
end
