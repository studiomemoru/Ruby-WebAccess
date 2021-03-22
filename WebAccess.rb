#encoding: utf-8
#==========================================
# Very simple Web API Access Library
#   by studio memoru
#   Copyright(c) 2018 by YOSHIMURA Takanori
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
  end

  def setQuery(str)
    @uri.query = str
  end

  def post(body, headers)
    req = Net::HTTP::Post.new(@uri.request_uri, headers)
    req.body = body
    @response = @http.request(req)
  end

  def postJson(payload)
    post(JSON.generate(payload), {'Content-Type' => 'application/json'})
  end

  def result(&block)
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

  api.result do |res|
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
