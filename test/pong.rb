t = SimpleTest.new "Main Pong Tests"

t.assert("create and return pong instance with default config") do
  app = Pong.new

  t.assert_equal app.config.port, 4321
  t.assert_equal app.config.host, '127.0.0.1'
  t.assert_equal app.config.threads, 10
end

t.assert("create and return pong instance with custom config") do
  app = Pong.new({
    port: 8080,
  })

  t.assert_equal app.config.port, 8080
end

t.assert("create and return pong instance with router") do
  app = Pong.new

  t.assert_equal app.routes.nil?, false
end

t.assert("pong instance respond to methods") do
  app = Pong.new

  t.assert_equal app.respond_to?(:run), true
  t.assert_equal app.respond_to?(:get), true
  t.assert_equal app.respond_to?(:post), true
  t.assert_equal app.respond_to?(:put), true
  t.assert_equal app.respond_to?(:head), true
  t.assert_equal app.respond_to?(:patch), true
  t.assert_equal app.respond_to?(:delete), true
  t.assert_equal app.respond_to?(:options), true
end

t.assert("kernel json method return hash with correct params") do
  hash = json Hash[foo: 'bar'], 404
  response = {
    headers: { 'Content-Type' => 'application/json; charset=utf-8' },
    status: 404,
    body: "{\"foo\":\"bar\"}"
  }

  t.assert_equal hash, response
end

t.assert("kernel html metho return hash with correct params") do
  hash = html '<h1>Hello from PONG</h1>'
  response = {
    headers: { 'Content-Type' => 'text/html; charset=utf-8' },
    status: 200,
    body: '<h1>Hello from PONG</h1>'
  }

  t.assert_equal hash, response
end

t.assert("kernel method redirect_to return hash with correct params") do
  hash = redirect_to '/'
  response = {
    headers: { 'Location' => '/' },
    status: 301,
    body: ''
  }

  t.assert_equal hash, response
end

t.report

t = SimpleTest.new "Pong::Parser tests"

t.assert("can parse raw request string and return hash") do
  raw_request = "GET /hello.html HTTP/1.1\r\nUser-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)\r\nHost: www.example.com\r\n\r\n"
  request = {
    headers: {
      'User-Agent' => 'Mozilla/4.0 (compatible; MSIE5.01; Windows NT)',
      'Host' => 'www.example.com'
    }, 
    params: nil,
    url: '/hello.html',
    method: 'GET',
    http_version: 'HTTP/1.1'
  }

  t.assert_equal Parser.new.request(raw_request), request
end

t.assert("can parse response to raw response string") do
  hash_response = {
    headers: { 'Location' => '/' },
    status: 301,
    body: ''
  }
  response = "HTTP/1.1 301\r\nLocation: /\r\n\r\n"
  
  t.assert_equal Parser.new.response(hash_response), response
end

t.report

t = SimpleTest.new "Pong::HandlerPool tests"

t.assert("pool instance respond to methods") do
  pool = HandlerPool.new

  t.assert_equal pool.respond_to?(:schedule), true
  t.assert_equal pool.respond_to?(:shutdown), true
end

t.report

t = SimpleTest.new "Pong::Config tests"

t.assert("create config with default params") do
  config = Config.new
  
  t.assert_equal config.port, 4321
  t.assert_equal config.host, '127.0.0.1'
end

t.assert("create config with custom params") do
  config = Config.configure do |conf|
    conf.port = 8080
    conf.threads = 12
  end

  t.assert_equal config.port, 8080
  t.assert_equal config.threads, 12
end

t.assert("create custom config from hash") do
  config = Config.from_hash({
    port: 8080,
    threads: 12
  })

  t.assert_equal config.port, 8080
  t.assert_equal config.threads, 12
end

t.report