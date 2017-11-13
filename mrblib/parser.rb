##
# This Parser can parse HTTP Requests and Responsed
# All Parsed data will be returned as Hash
#
class Parser

  SEP = "\r\n"
  C_TYPES = %w(application/json application/x-www-form-urlencoded multipart/form-data)

  DEFAULTS = {
    "status" => 200,
  }

  ##
  # Parse RAW Request String
  # This method will parse all HTTP Request information
  # and returned as Hash
  # 
  # Example Response:
  # {
  #   headers: { 'Accept' => '*/*', 'Content-Type' => 'application/json' },
  #   url:     '/foobar',
  #   method:  'GET',
  #   params:  { 'foo' => 'bar' } 
  # }
  #
  # Params: 
  # - raw_data {String} RAW Request String
  #
  # Response:
  # - data {Hash} Parse Request information
  #
  def request(raw_data)
    headers = {}
    params  = {}
    url     = nil
    method  = nil
    http_v  = nil

    if raw_data.include?(SEP * 2)
      raw_headers, raw_body = raw_data.split(SEP + SEP, 2)
    else
      raw_headers = raw_data
    end

    raw_headers = raw_headers.split(SEP)
    
    if raw_headers[0].include?("HTTP/1")
      method, url, http_v = raw_headers[0].split(" ", 3)
    end

    headers = parse_headers(raw_headers)
    params  = parse_params(raw_body, headers['Content-Type'])

    { 
      headers:      headers,
      params:       params,
      url:          url,
      method:       method,
      http_version: http_v
    }
  end

  ##
  # This method will create a raw HTTP Response from sended params
  #
  # Params:
  # - response {Hash} Returned from action Hash
  #
  # Response:
  # - raw_response {String} RAW HTTP Response
  # 
  def response(response)

  end

private

  ##
  # Parse Headers and returned Hash with Headers
  # 
  # Params: 
  # - raw_headers {Array} Array of unparsed HTTP headers
  #
  # Response:
  # - headers {Hash} Hash of parsed HTTP headers
  #
  def parse_headers(raw_headers)
    raw_headers.each do |l|
      
      if l.include?(": ")
        k, v = l.split(": ")

        if !headers[k].nil?
          if headers[k].kind_of?(Array)
            headers[k] << v
          else
            headers[k] = [headers[k], v]
          end
        else
          headers[k] = v
        end
      end
    end

    headers
  end

  ##
  # Parse Request body depending on Content-Type header
  #
  # Params:
  # - raw_body {String} raw HTTP Request Body
  # - c_type   {String} body Content-Type
  #
  # Response:
  # - params {Hash} parsed Hash with sended params
  #
  def parse_params(raw_body, c_type)
    params = {}

    if C_TYPES[0] == c_type
      return raw_body.to_json
    elsif C_TYPES[1] == c_type
      if raw_body.include?('&')
        raw_body = raw_body.split('&')

        raw_body.each do |l|
          if raw_body.include?('=')
            k, v = raw_body.split('=')

            params[k] = v
          end
        end
      else
        if raw_body.include?('=')
          k, v = raw_body.split('=')

          params[k] = v
        end
      end
    elsif C_TYPES[2] == c_type
      # TODO: need to implement multipart/form-data parser
    end
  end
end