class Routes
  ##
  # Initialize new Routes struct
  #
  # Params:
  # - New
  #
  # Response:
  # - Return Empty Routes table
  #
  def initialize
    @table = {
      "GET"    => {},
      "POST"   => {},
      "PUT"    => {},
      "PATCH"  => {},
      "DELETE" => {},
      "OPTION" => {}
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
    @table[method][url]
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
end