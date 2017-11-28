## Welcome to mruby-pong page

[![Build Status](https://travis-ci.org/nsheremet/mruby-pong.svg?branch=master)](https://travis-ci.org/nsheremet/mruby-pong) [![MRuby Version](https://img.shields.io/badge/mruby-v1.3.0-green.svg)](https://github.com/mruby/mruby)

MRuby-pong it's a simple web server for building simple Sinatra-like applications.

![mruby-pong-example](https://i.imgur.com/2Cvm6ba.gif)

## Installation

Add line to your `build_config.rb`

```ruby
MRuby::Build.new do |config|
  # some lines of your config
  config.gem :github => 'nsheremet/mruby-pong'
  # other lines of your config
end
```

## Usage

Simple App:

```ruby
app = Pong.new

app.get '/' do
  html '<h1>Hello from PONG</h1>'
end

app.run
```

Your can user custom configuration:

```ruby
app = Pong.new({
    port: 8080,
    threads: 24,
    debug: true
})
```

Request handling examples:

```ruby
app.post '/users' do |request|
  # request have a structure
  # {
  #   params: {Hash},
  #   headers: {Hash},   
  #   method: {String}, additional fields,
  #   url: {String}, additional fields
  # }
  
  params: request[:params]

  json Hash[params: params], 201, headers # Status Code and Headers are optional
end
```

What I need to return in action?

```ruby
# HTML
html page, status_code, headers # page is string with HTML content

# JSON
json hash, status_code, headers

# Redirect
redirect_to '/' # accept only one String param

# RAW hash
# You can return what you want, just create hash with required 'Content-Type' header
{
    headers: { 'Content-Type' => 'text/xml' }, # You need to setup Content-Type headers
    status: 200,
    body: '<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don\'t foget me this weekend!</body></note>'
}

```

## Contributing

See [CONTRIBUTING](https://github.com/nsheremet/mruby-pong/blob/master/CONTRIBUTING.md) for details.


## License

`mruby-pong` is primarily distributed under the terms of Mozilla Public License 2.0.

See [LICENSE](https://github.com/nsheremet/mruby-pong/blob/master/LICENSE) for details.
