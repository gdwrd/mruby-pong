##
# Class: routes object
#
# This class is the main router for every action/request in Pong
#
class Routes

  ##
  # Constructor:
  #
  # Returns new rotues instance
  #
  # Params:
  # - None
  #
  # Response:
  # - routes {Routes}
  #
  def initialize
    @table = {
      "GET"     => {},
      "POST"    => {},
      "PUT"     => {},
      "PATCH"   => {},
      "DELETE"  => {},
      "OPTIONS" => {},
      "HEAD"    => {}
    }
  end

  ##
  # Returns proc for request method and url
  #
  # Params:
  # - method {String} Request HTTP Method: [GET, POST, PUT, PATCH, DELETE, OPTION]
  # - url    {String} Request URL, Example: "/users/new"
  #
  # Response:
  # - block {Proc} returned block
  #
  def block(method, url)
    block = @table[method][url]
    block.nil? ? not_found : block
  end

  ##
  # Add new Procs to table
  # 
  # Params:
  # - method {String} Request HTTP Method
  # - url    {String} Request URL
  # - block  {Block}  Request Action block
  #
  # Response:
  # - None
  #
  def push(method, url, block)
    @table[method][url] = block
  end

private

  ##
  # Default error page if Routes or Page not found
  #
  # Params:
  # - None
  #
  # Response:
  # - block {Proc} block with default response error and params
  #
  def not_found
    Proc.new { { headers: {}, body: 'Page Not Found', status: 404 } }
  end
end