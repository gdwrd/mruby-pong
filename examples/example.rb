pong = Pong.new

pong.get '/hello' do |req|
  if req.params[:foo] == "bar"
    return { "text" => "foobar" }
  else 
    return status: 404
  end
end
