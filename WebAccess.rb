#encoding: utf-8
#==========================================
# Very simple Web API Access Library
#   by studio memoru
#   Copyright(c) 2018-2021 by YOSHIMURA Takanori
#==========================================

require 'net/http'
require 'uri'
require 'json'

class WebAccess
  attr_reader :response

  def initialize(url, use_ssl=true)
    @uri = URI.parse(url)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = use_ssl
    @header = Hash.new
  end

  def setHeader(key, value)
    @header[key] = value
  end

  def setQuery(str)
    @uri.query = str
  end

  def get(params=nil)
    query = nil
    if params.is_a?(Hash)
      query = URI.encode_www_form(params)
    elsif !params.nil?
      query = params.to_s
    end
    
    unless query.nil?
      if @uri.query.nil?
        @uri.query = query
      else
        @uri.query += '&' + query
      end
    end

    @response = @http.request_get(@uri.request_uri, @header)
  end

  def post(body)
    req = Net::HTTP::Post.new(@uri.request_uri, @header)
    req.body = body
    @response = @http.request(req)
  end

  def postJson(payload)
    @header['Content-Type'] = 'application/json'
    post(JSON.generate(payload))
  end

  def postForm(params)
    query = nil
    if params.is_a?(Hash)
      query = URI.encode_www_form(params)
    elsif !params.nil?
      query = params.to_s
    end
    post(query)
  end

  def process(&block)
    if @response.is_a?(Net::HTTPSuccess)
      block.call(@response)
    else
      @response.value
    end
  end

end

#==========================================
=begin
Example:

url = 'https://httpbin.org/post'
payload = {
  "msg" => "Hello",
  "context" => "aaabbbccc111222333"
}

api = WebAccess.new(url)
api.setQuery('APIKEY=1234')

begin
  api.postJson(payload)
  puts "code -> #{api.response.code}"

  api.process do |res|
    res.each_capitalized_name do |name|
      value = res[name]
      puts "#{name} = #{value}"
    end
    puts "body -> #{res.body}"
  end
rescue => err_obj
  warn(err_obj.to_s)
end

=end
