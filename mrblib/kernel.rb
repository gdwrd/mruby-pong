##
# Module: Kernel Module
#
# Adding custom methods to Kernel module
#
module Kernel
  ##
  # Prepare response to return JSON with Content-Type application/json
  #
  # Params:
  # - body   {Hash} Response JSON Body
  # - status {Int}  Response Status code (Defautl: 200)
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
  # Prepare response to return HTML
  #
  # Params:
  # - body {String} Raw HTML body
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
  # Prepare response to redirect
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