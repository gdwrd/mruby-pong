class Pong
  attr_reader :config

  RECV_BUFFER = 2048 # 1024

  ##
  # Initialize Pong Router
  #
  # Params: None
  #
  # Response: Pong class instance
  #
  def initialize(config)
    @config = Config.new
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
  # Server starts Listening for the requests
  #
  # Params:
  # - None
  #
  # Response: 
  # - None
  #
  def serve
    server = TCPServer.new(config.host, config.port)

    loop do
      conn = socket.accept

      begin
        request_raw  = receive_data(conn)
        response_raw = handle_request(request_raw)

      rescue => exception
        
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
    request = @parser.request(raw_data)
    action  = @routes.block(request[:method], request[:url])

    response = action.call(request)
    
    parser.response(response)
  end

end