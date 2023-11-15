module ExceptionHandler
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
  class InvalidParameters < BaseException; end
  class AccountNotFound < BaseException; end
  class UnAuthorized < BaseException; end
  class AccountNotVerified < BaseException; end
  class DuplicateRecord < BaseException; end
  class Forbidden < BaseException; end
  class UnprocessableEntity < BaseException; end
  class InvalidReflection < BaseException; end
  class ResourceAlreadyAltered < BaseException; end

  included do
    rescue_from StandardError, with: :default_error
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::AccountNotFound, with: :not_found
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::AccountNotVerified, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidParameters, with: :invalid_parameters
    rescue_from ExceptionHandler::Forbidden, with: :access_forbidden
    rescue_from ExceptionHandler::DuplicateRecord, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :missing_parameters
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_not_valid
    rescue_from ExceptionHandler::UnprocessableEntity, with: :four_twenty_two
    rescue_from CanCan::AccessDenied, with: :can_can_forbidden
    rescue_from ExceptionHandler::InvalidReflection, with: :invalid_reflection
    rescue_from ActiveRecord::DeleteRestrictionError, with: :unprocessable_entity
    rescue_from NoMethodError, NameError, ArgumentError, ActiveRecord::StatementInvalid, with: :internal_server_error
    rescue_from ExceptionHandler::ResourceAlreadyAltered, with: :resource_conflict
  end

  private

  def log(e, method)
    log_error_to_console(e)
    log_error_to_sentry(e, method)
  end

  def log_error_to_sentry(exception, method)
    except_logger.info("#{method.to_s.humanize} #{exception.message}")
    except_logger.info("Full trace #{exception.backtrace.join("\n")}")
  end

  def log_error_to_console(exception)
    if exception.class.name.match?("ExceptionHandler::") || exception.class.name.in?(["ActiveRecord::RecordInvalid", "ActiveRecord::RecordNotFound"])
      logger.warn("#{exception.class.name} (#{exception.message})")
    else
      logger.error("#{exception.class.name} (#{exception.message}):\n\t\t\t\t\t       #{exception.backtrace.take(5).join("\n\t\t\t\t\t       ")}")
    end
    backtrace = exception.class.name.match?("ExceptionHandler::") ? "" : ":\n\t\t\t\t\t       #{exception.backtrace.take(5).join("\n\t\t\t\t\t       ")}"
  end

  def four_twenty_two(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, error_type: e.class.name, message: e.message, backtrace: e.backtrace.take(5), status: :unprocessable_entity)
  end

  def unprocessable_entity(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :unprocessable_entity)
  end

  def something_went_wrong(e)
    log(e, __method__)
    response_json_error(error: "Something went wrong", message: "Something went wrong", status: :unprocessable_entity)
  end

  def unauthorized_request(e)
    log(e, __method__)
    response_json_error(error: e.error, message: e.message, data: e.data, status: :unauthorized)
  end

  def invalid_parameters(e)
    log(e, __method__)
    response_json_error(error: e.error, message: e.message, status: :expectation_failed)
  end

  def missing_parameters(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :unprocessable_entity)
  end

  def not_found(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :not_found)
  end

  def record_not_found(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: I18n.t("errors.record_not_found"), status: :not_found)
  end

  def access_forbidden(e)
    log(e, __method__)
    response_json_error(error: e.error, message: e.message, data: e.data, status: :forbidden)
  end

  def can_can_forbidden(e)
    log(e, __method__)
    respond_to do |format|
      format.json { render json: { error: "action_unauthorized", message: I18n.t("errors.action_unauthorized") }, status: :forbidden }
      format.html { redirect_to "/admin", error: I18n.t("errors.action_unauthorized") }
      flash[:notice] = I18n.t("errors.action_unauthorized")
    end
  end

  def invalid_reflection(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :bad_request)
  end

  def resource_conflict(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :conflict)
  end

  def default_error(e)
    logger.fatal("UNHANDLED EXCEPTION: #{e.class.name}, MESSAGE: #{e.message}")
    logger.fatal("SWALLOWING AND RETURNING INTERNAL SERVER ERROR")
    log(e, __method__)
    internal_server_error(e, unhandled: true)
  end

  def internal_server_error(e, unhandled: false)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error,
                        message: I18n.t("errors.something_went_wrong"),
                        error_type: e.class.name,
                        unhandled: unhandled,
                        backtrace: e.backtrace.take(5),
                        status: :internal_server_error)
  end

  def record_not_valid(e)
    log(e, __method__)
    render json: { error: "VALIDATION_FAILED",
                  message: e.message,
                  record: { is_persisted: !e.record.new_record?, id: e.record.id, type: e.record.class.name.underscore } }, status: :unprocessable_entity
  end

  def except_logger
    Logger.new("#{Rails.root}/log/exceptions.log")
  end
end
