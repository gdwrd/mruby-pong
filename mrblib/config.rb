##
# Class: config object
#
# This class used for creating configuration for pong class
#
class Config
  attr_accessor :port, :host, :ssl_enabled, :debug

  DEFAULT_HOST = '127.0.0.1'
  DEFAULT_PORT = 4321
  SSL_ENABLED  = false

  ##
  # Constructor:
  #
  # Initialize defautl Pong Router Configuration
  #
  # Params:
  # - None
  #
  # Response:
  # - Config instance with default configuration
  #
  def initialize
    @host        = DEFAULT_HOST
    @port        = DEFAULT_PORT
    @ssl_enabled = SSL_ENABLED
    @debug       = false
  end

  class << self
    ##
    # Configure new Pong configurations
    #
    # Params:
    # - port        {Int}     Port
    # - ssl_enabled {Boolean} SSL Enabled?
    #
    # Response:
    # - Config instance
    #
    def configure
      config = Config.new

      yield config

      config
    end
  end
end