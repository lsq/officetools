#!/usr/bin/env ruby
#

require 'net/http'
require 'json'
require 'date'
require 'digest/md5'
require 'curb'

# DateTime.now.strftime('%Q')

wdku_uri = 'https://ocr.wdku.net/Upload'

# uri = URI(wdku_uri)

# c = Curl::Easy.new(wdku_uri)
# c.multipart_form_post = true
# if c.http_post(Curl::PostField.file('file', 'd.jpg')) then
	# upload_info = JSON.parse(c.body_str)
# end
upload_info = Curl::Easy.new(wdku_uri) do |curl|
  curl.multipart_form_post = true
  curl.http_post(Curl::PostField.file('file', 'd.jpg')) 
  puts curl.class
  #curl.on_body {|body_data| puts "success, the body data are #{body_data}!"}
  puts curl.body_str
	#curl.on_success do |upload_code|
	#	puts "上传成功！"
		@upload_id = JSON.parse(curl.body_str)["data"]["id"]
	#end
end
	
puts upload_info
puts @upload_id
