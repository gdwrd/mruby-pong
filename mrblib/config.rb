##
# Class: config object
#
# This class used for creating configuration for pong class
#
class Config
  attr_accessor :port, :host, :ssl_enabled, :debug, :threads

  DEFAULT_HOST    = '127.0.0.1'
  DEFAULT_PORT    = 4321
  SSL_ENABLED     = false # Currently SSL didn't work
  DEFAULT_THREADS = 10
  
  ##
  # Constructor:
  #
  # Initialize default Pong Configuration
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
    @ssl_enabled = SSL_ENABLED # TODO: need to add SSL Support
    @debug       = false
    @threads     = DEFAULT_THREADS
  end

  ##
  # Class methods for configuration
  #
  class << self

    ##
    # Configure new Pong configurations
    #
    # Params:
    # - host        {String}  host string
    # - port        {Int}     Port
    # - ssl_enabled {Boolean} SSL Enabled?
    # - debug       {Boolean} Show debug messages
    # - threads     {Int}     Number of threads
    #
    # Response:
    # - Config instance
    #
    def configure
      config = Config.new

      yield config
      
      config
    end

    ##
    # Create new configuration for Pong from Hash
    #
    # Params:
    # - hash {Hash} hash with configurations
    #
    # Response:
    # - config {Config} configuration
    #
    def from_hash(hash)
      Config.configure do |c|
        c.host    = hash[:host] || c.host
        c.port    = hash[:port] || c.port
        c.debug   = hash[:debug] || c.debug
        c.threads = hash[:threads] || c.threads

        # SSL didn't work
        c.ssl_enabled = hash[:ssl_enabled] || c.ssl_enabled # need to add SSL Support
      end
    end
  end
end