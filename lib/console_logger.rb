require "logger"
require "rainbow/refinement"
using Rainbow

class ConsoleLogger
  include Singleton

  LOG_LEVEL_COLORS = {
    DEBUG: :cyan,
    INFO: :green,
    WARN: :yellow,
    ERROR: :red,
    FATAL: :red,
  }

  def initialize
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S %z"
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "  [#{datetime.strftime(@logger.datetime_format)} ##{Process.pid}] #{severity} -- : #{msg}\n".send(LOG_LEVEL_COLORS[severity.to_sym])
    end
    return @logger
  end

  def set_log_level(log_level)
    case log_level.downcase
    when "debug"
      @logger.level = Logger::DEBUG
    when "info"
      @logger.level = Logger::INFO
    when "warn"
      @logger.level = Logger::WARN
    when "error"
      @logger.level = Logger::ERROR
    when "fatal"
      @logger.level = Logger::FATAL
    end
  end

  def logger
    @logger
  end

  def log_with_current_severity(message)
    @logger.add(@logger.level, message)
  end
end
