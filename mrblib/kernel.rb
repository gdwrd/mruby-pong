##
# Module: MRuby Kernel Module
#
# Adding custom methods to MRuby Kernel Module
# Methods allow you to send different types of responses
# for each request
#
module Kernel

  ##
  # Prepare response to return JSON with Content-Type `application/json`
  #
  # Params:
  # - body    {Hash} Response JSON Body
  # - status  {Int}  Response Status code, default: 200
  # - headers {Hash} Response Headers, default: {} - (empty hash)
  #
  # Response:
  # - response {Hash} Prepared Hash with all response info
  # 
  def json(data, status = 200, headers = {})
    headers['Content-Type'] = 'application/json; charset=utf-8'

    return {
      headers: headers,
      status: status,
      body: data.to_json
    }
  end

  ##
  # Prepare response to return HTML page, with Content-Type `text/html`
  #
  # Params:
  # - body    {String} Raw HTML body
  # - status  {Int}    Response Status Code, default: 200
  # - headers {Hash}   Response Headers, default: {} - (empty hash)
  #
  # Response:
  # - response {Hash} Prepared Hash with all response info
  #
  def html(data, status = 200, headers = {})
    headers['Content-Type'] = 'text/html; charset=utf-8'

    return {
      headers: headers,
      status: status,
      body: data
    }
  end

  ##
  # Prepare response to redirect to another location
  #
  # Params:
  # - location {String} new location to redirect
  #
  # Response:
  # - response {Hash} Prepared Hash with all response info
  #
  def redirect_to(location)
    headers = {
      'Location' => location
    }
    
    return {
      headers: headers,
      status: 301,
      body: ''
    }
  end
end