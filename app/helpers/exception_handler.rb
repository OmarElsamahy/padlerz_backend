module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  class BaseException < StandardError
    attr_reader :error
    attr_reader :message
    attr_reader :data

    def initialize(error: "", message: "", data: {}, params: {})
      @message = message.present? ? message : I18n.t("errors.#{error}")
      @error = error
      @data = data
    end
  end

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < BaseException; end
  class MissingToken < BaseException; end
  class InvalidToken < BaseException; end
  class InvalidDeviceId < BaseException; end
  class InvalidUserData < BaseException; end
  class InvalidCode < BaseException; end
  class GuestUnAuthorized < BaseException; end
  class InvalidParameters < BaseException; end
  class ArgumentError < BaseException; end
  class AccountNotFound < BaseException; end
  class UnAuthorized < BaseException; end
  class AccountNotVerified < BaseException; end
  class DuplicateRecord < BaseException; end
  class Forbidden < BaseException; end
  class UnprocessableEntity < BaseException; end

  included do
    rescue_from ExceptionHandler::GuestUnAuthorized, with: :guest_not_allowed
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::AccountNotFound, with: :not_found
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidDeviceId, with: :four_twenty_two
    rescue_from ExceptionHandler::AccountNotVerified, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidUserData, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidCode, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidParameters, with: :invalid_parameters
    rescue_from ExceptionHandler::ArgumentError, with: :invalid_parameters
    rescue_from ExceptionHandler::Forbidden, with: :access_forbidden
    rescue_from ExceptionHandler::DuplicateRecord, with: :four_twenty_two
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :missing_parameters
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::UnprocessableEntity, with: :four_twenty_two
    rescue_from CanCan::AccessDenied, with: :can_can_forbidden
  end

  def can_can_forbidden(e)
    respond_to do |format|
      format.json { render json: { error: "action_unauthorized", message: I18n.t("errors.action_unauthorized") }, status: :forbidden }
      format.html { redirect_to "/admin", error: I18n.t("errors.action_unauthorized") }
      flash[:notice] = I18n.t("errors.action_unauthorized")
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    excep_logger.info("442 #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :unprocessable_entity)
  end

  def something_went_wrong(e)
    excep_logger.info("Something went wrong #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: "Something went wrong", message: "Something went wrong", status: :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    excep_logger.info("Unauthorized #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message: e.message, data: e.data, status: :unauthorized)
  end

  def fb_request(e)
    excep_logger.info("FB request #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message: e.message, status: e.http_status)
  end

  # JSON response with message; Status code 417 - Expectation Failed
  def invalid_parameters(e)
    excep_logger.info("Invalid Params #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message: e.message, status: :expectation_failed)
  end

  def missing_parameters(e)
    excep_logger.info("Missing Params #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :expectation_failed)
  end

  # JSON response with message; Status code 405 - Method Not Allowed
  def guest_not_allowed(e)
    excep_logger.info("Guest not allowed #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message: e.message, status: :method_not_allowed)
  end

  # JSON response with message; Status code 404 - Not Found
  def not_found(e)
    excep_logger.info("Record not found #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :not_found)
  end

  # JSON response with message; Status code 500 - Internal Server Error
  def default_error(e)
    excep_logger.info("Default Error #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message: e.message, status: :server_error)
  end

  # JSON response with message; Status code 403 - Forbidden
  def access_forbidden(e)
    excep_logger.info("Access Forbidden #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message: e.message, data: e.data, status: :forbidden)
  end

  def excep_logger
    logger ||= Logger.new("#{Rails.root}/log/exceptions.log")
    logger
  end
end
