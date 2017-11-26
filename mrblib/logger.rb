##
# Class: logger class
#
# Allows you to logging each information
#
class Logger

  ##
  # Constructor
  # 
  # Provides logging with timestamps and different logging levels
  # With saving all messages to log files
  #
  # Params:
  # - file_path {String} Path to file, where you want to store your app logs, default: 'pong.log'
  #
  # Response:
  # - logger {Logger}
  #
  def initialize(file_path = 'pong.log')
    @file = File.open(file_path, 'a')
  end

  ##
  # Log messages with log level INFO
  #
  # Params:
  # - message {String}
  #
  # Resppnse:
  # - None
  #
  def info(message)
    log(:info, message)
  end

  ##
  # Log messages with log level CRITICAL
  #
  # Params:
  # - message {String}
  #
  # Resppnse:
  # - None
  #
  def critical(message)
    log(:critical, message)
  end

  ##
  # Log messages with log level WARNING
  #
  # Params:
  # - message {String}
  #
  # Resppnse:
  # - None
  #
  def warning(message)
    log(:warning, message)
  end

  ##
  # Log messages with log level DEBUG
  #
  # Params:
  # - message {String}
  #
  # Resppnse:
  # - None
  #
  def debug(message)
    log(:debug, message)
  end

  ##
  # Log messages with log level ERROR
  #
  # Params:
  # - message {String}
  #
  # Resppnse:
  # - None
  #
  def error(message)
    log(:error, message)
  end

  ##
  # Prints Welcome Pong logo
  #
  # Params:
  # - None
  #
  # Response:
  # - None
  #
  def welcome_logo
    puts "
        ██▓███   ▒█████   ███▄    █   ▄████ 
      ▓██░  ██▒▒██▒  ██▒ ██ ▀█   █  ██▒ ▀█▒
      ▓██░ ██▓▒▒██░  ██▒▓██  ▀█ ██▒▒██░▄▄▄░
      ▒██▄█▓▒ ▒▒██   ██░▓██▒  ▐▌██▒░▓█  ██▓
      ▒██▒ ░  ░░ ████▓▒░▒██░   ▓██░░▒▓███▀▒
      ▒▓▒░ ░  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ░▒   ▒ 
      ░▒ ░       ░ ▒ ▒░ ░ ░░   ░ ▒░  ░   ░ 
      ░░       ░ ░ ░ ▒     ░   ░ ░ ░ ░   ░ 
                    ░ ░           ░       ░ 
                                            
    "
  end

private

  ##
  # Puts logging information to file and screen
  #
  # Params:
  # - log_level {Symbol}
  # - message   {String}
  #
  # Response:
  # - None
  #
  def log(log_level, message)
    msg_line = format_message(log_level, message)

    @file.puts(msg_line)
    puts msg_line
  end

  ##
  # Format messages with timestampz and log level
  #
  # Params:
  # - log_level {Symbol}
  # - message   {String}
  #
  # Response:
  # - None
  #
  def format_message(log_level, message)
    "[#{Time.now}] #{log_level.to_s.upcase} -- #{message}"
  end
end