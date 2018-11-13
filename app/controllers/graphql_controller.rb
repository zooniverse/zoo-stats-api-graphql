require_relative '../graphql/utilities/credential'

class GraphqlController < ApplicationController
  attr_reader :credential
  before_action :setup_and_validate_credential

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user,
      admin: admin_status
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

  def setup_and_validate_credential
    authorization = request.headers['HTTP_AUTHORIZATION']
    match = /\ABearer (.*)\Z/.match(authorization)

    return unless match
    auth = match[1]
    temp = Credential.new(auth)
    @credential = temp if temp.ok?
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
