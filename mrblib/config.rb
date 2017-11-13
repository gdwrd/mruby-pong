class Config
  attr_accessor :port, :ssl_enabled

  DEFAULT_HOST = '127.0.0.1'
  DEFAULT_PORT = 4321
  SSL_ENABLED  = false

  ##
  # Initialize defautl Pong Router Configuration
  #
  # Params:
  # - None
  #
  # Response:
  # - Config instance with default configuration
  #
  def initialize
    self.host        = DEFAULT_HOST
    self.port        = DEFAULT_PORT
    self.ssl_enabled = SSL_ENABLED
  end

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
    yield self
  end
end