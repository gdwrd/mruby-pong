pong = Pong.new

pong.get('/') do
  { headers: {}, body: 'Hello from PONG', status: 200 }
end

pong.post('/route1') do |request|
  json Hash[params: request[:params]]
end

pong.get('/route2') do
  html '<h1>Hello from PONG</h1>'
end

pong.get('/route3') do
  redirect_to '/'
end

pong.run
