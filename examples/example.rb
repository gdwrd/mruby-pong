app = Pong.new({
  port: 8080,
  threads: 8
})

app.get('/') do
  html '<h1>Hello from Pong</h1>'
end

app.get('/foo') do 
  json Hash[foo: 'bar'], 200
end

app.post('/bar') do |request|
  json Hash[params: request[:params]]
end

app.get('/admin') do
  redirect_to '/'
end

app.run