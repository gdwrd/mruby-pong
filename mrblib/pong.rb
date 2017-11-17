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

    @logger = Logger.new 
    @routes = Routes.new
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

    loop do
      connection = socket.accept

      begin
        request_raw = ''
          
        loop do
          buffer = connection.recv(2048)
          request_raw << buffer

          break if buffer.size != 2048
        end

        if !request_raw.empty?
          response_raw = handle_request(request_raw)
          connection.send(response_raw, 0)
        end
      rescue => error
        raise error if @config.debug && connection.closed?
      ensure
        connection.close
      end
    end
  end

private

  ##
  # Receive data from Connection
  #
  # Params:
  # - conn {Connection}
  #
  # Response:
  # - data {String} Readed data from Connection
  #
  def receive_data(conn)
    data = ''

    loop do
      buffer = conn.recv(RECV_BUFFER)
      data << buffer

      return data if buffer.size != RECV_BUFFER
    end
  end

  ##
  # Parse and Handle RAW Request with Router Actions
  #
  # This method parse Request, and send handled request
  # to router table blocks.
  # Then method generates from action raw response string.
  #
  # Params:
  # - request_raw {String} Request String
  #
  # Response:
  # - response_raw {String} Returns response for current request
  #
  def handle_request(raw_data)
    parser = Parser.new
    request = parser.request(raw_data)
    action  = @routes.block(request[:method], request[:url])
    c_type = request[:headers]['Content-Type']

    begin
      data = action.call(request)
    rescue => error
      data = internal_server_error(c_type)

      @logger.error(error.message)
    end

    response = complete_response(data)
    @logger.info("#{request[:method]} request to '#{request[:url]}' #{response[:status]}")
    parser.response(response)
  end

  ##
  # Add to response additional required information
  # here is adding defautls headers
  #
  # Params:
  # - response {Hash}
  #
  # Response:
  # - response {Hash}
  #
  def complete_response(response)
    response[:headers]['Content-Length'] = response[:body].size
    response[:headers]['Connection'] = 'Closed'
    response[:headers]['Date'] = Time.now.to_s
    response[:status] = 200 if response[:status].nil?
    
    response
  end

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
end