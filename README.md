# Very simple Web API Access Library for Ruby

Tested on Ruby 2.3.0 and 2.3.3.

Example:
```
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
```
