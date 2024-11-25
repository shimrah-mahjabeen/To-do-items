class GraphqlController < ApplicationController
  before_action :set_cors_headers
  before_action :authenticate_user!

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: @current_user, # Set the current_user from the decoded JWT
    }

    result = TodoGraphqlSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    if Rails.env.development?
      handle_error_in_development(e)
    else
      raise e
    end
  end

  private

  # Authenticate the user based on the JWT token, skipping for specific mutations
  def authenticate_user!
    return if public_mutation?

    token = request.headers['Authorization']&.split(' ')&.last
    unless token
      render json: { errors: ['Not Authorized'] }, status: :unauthorized and return
    end
  
    decoded_token = JwtService.decode(token)

    if decoded_token && decoded_token[:user_id]
      @current_user = User.find_by(id: decoded_token[:user_id])
    else
      render json: { errors: ['Not Authorized'] }, status: :unauthorized
    end
  end

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = 'http://test-project-sjnks.s3-website-us-east-1.amazonaws.com'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'
  end

  # Check if the query is for public mutations
  def public_mutation?
    public_mutations = %w[loginUser signUpUser]
    params[:query].present? && public_mutations.any? { |mutation| params[:query].include?(mutation) }
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
