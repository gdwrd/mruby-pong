##
# Class: pong object
#
# Allows you create action blocks for every request
#
class Pong
  attr_reader :config, :router, :parser

  RECV_BUFFER = 2048

  ##
  # Constructor:
  #
  # Initialize Pong Router
  #
  # Params: None
  #
  # Response: Pong class instance
  #
  def initialize(config = nil)
    @config = config || Config.new
    @routes = Routes.new
    @logger = Logger.new 
    @parser = Parser.new
  end

  ##
  # Handle Blocks of code to Router
  #
  # Params:
  # - method {String} Request HTTP Method
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def handle(method, url, &block)
    @routes.push(method, url, block)
  end

  ##
  # Handle GET Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def get(url, &block)
    handle('GET', url, &block)
  end

  ##
  # Handle POST Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def post(url, &block)
    handle('POST', url, &block)
  end

  ##
  # Handle PUT Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def put(url, &block)
    handle('PUT', url, &block)
  end

  ##
  # Handle PATCH Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def patch(url, &block)
    handle('PATCH', url, &block)
  end

  ##
  # Handle DELETE Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def delete(url, &block)
    handle('DELETE', url, &block)
  end

  ##
  # Handle OPTIONS Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def options(url, &block)
    handle('OPTIONS', url, &block)
  end

  ##
  # Handle HEAD Request
  #
  # Params:
  # - url    {String} Request URL
  # - block  {Proc}   Request Application Action
  #
  # Response:
  # - None
  #
  def head(url, &block)
    handle('HEAD', url, &block)
  end

  ##
  # Server starts Listening for the requests
  #
  # Params:
  # - None
  #
  # Response: 
  # - None
  #
  def run
    @logger.welcome_logo
    @logger.info("Pong::run started port=#{@config.port}")
    socket = TCPServer.new(@config.host, @config.port)

    pool = HandlerPool.new(@config.threads)

    loop do
      pool.schedule(accept_connection(socket)) do |conn|
        next if conn.closed?

        begin
          request_raw = ''

          loop do
            buffer = conn.recv(2048)
            request_raw << buffer

            break if buffer.size != 2048
          end

          return if request_raw.empty?
          
          request = @parser.request(request_raw)
          action  = @routes.block(request[:method], request[:url])
          c_type  = request[:headers]['Content-Type']

          begin
            data = action.call(request)
          rescue => error
            data = internal_server_error(c_type)

            @logger.error(error.message)
          end
          
          data[:headers]['Content-Length'] = data[:body].size
          data[:headers]['Connection'] = 'Closed'
          data[:headers]['Date'] = Time.now.to_s
          data[:status] ||= 200
          
          @logger.info("#{request[:method]} request to #{request[:url]} #{data[:status]}")
          
          response_raw = @parser.response(data)
          conn.send(response_raw, 0)
        rescue
          @logger.critical("Connections reset by peer") if conn.closed?
        ensure
          conn.close
        end
      end
    end

    pool.shutdown
  end

private

  ##
  # Returns default server internal error
  #
  # Params:
  # - c_type {String} Request Content-Type value, default: 'text/html'
  # 
  # Response:
  # - response {Hash} Response with 500 Internal Server Error
  #
  def internal_server_error(c_type = 'text/html')
    return { 
      headers: { 'Content-Type' => c_type },
      body: '500 Internal Server Error',
      status: 500
    }
  end

  ##
  # Acceptiong new connection from socket
  # If something went wrong return nil
  #
  # Params:
  # - socket {TCPSocket} connetion socket
  #
  # Response:
  # - connection {TCPSocket} 
  #
  def accept_connection(socket)
    socket.accept
  rescue
    nil
  end
end