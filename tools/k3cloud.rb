#!/usr/bin/env ruby
#

require 'net/http'
require 'json'
require 'date'
require 'digest/md5'

jduri = 'https://aiapi.jd.com/jdai/ocr_universal_v2'
appkey = 'e31a789a6d08d265f834c9a420a2de9c'
imgbase64 = 'iVBORw0KGgoAAAANSUhEUgAAAF4AAAATCAYAAAAZFLrcAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAR9SURBVFhH7ZdfbBRFHMd/MQajgCgYiH8fjC1IK0KifTE+FIqukkZsLedDEQRbSgISwlVqJBESKTaQXKLBQrIVE5FYmvbQlHK16t6DmEKIGmu0tVCv2pYjmmrLE/77OjM3u7e3N3u3d24bQvgkv9zvfjszN/u5udk56uvrw9USF6p7C/lrzbauG5zXrrUQ4q/jjWg06insbVVcNeK3TDQulem0YxeWLbKhavtVRdVsmVp1F/H/okWbwM00jpn0G2bRJcymMcyhEdxGw7idhjCPBnFH8DKOfLd7k+ykxvgeD9DnKNCG8DN765wUMIljWiuW0jGs0ydkzZ1oNIzt1ITSkqPokGNNVXghlz78+pOXf7iR5y7i/xHiXzHkW2MCtwrxcbwbS5SG9WHMZ+I5Z8oPL+SvzkmYcbyeiacePMVendfa6sN4mD7EskAk7ZoqYJxEKRdPLWhnc1G1cYYrsU7sogBeoOfwuj4mi0nsY8w5GJ0pyyl1L6jauovX/5Q5w/gjTTxwBUf0SZknadfuf1ymFgN/V259X+tBIX2Bo1Z/PqFubKI2Jv4ETsuaif3mnNFR/zZernx0J8858fD+gEhyxTiEtbSGia/Ebof4oebnC2QqcM7BK25tXcQ7EOJHHeK9s2NG251F/QN3L6QIFgU+tSb/TqAdS+g46kJR3DdjvJzXupo2bDWvLzj8yD1mPiUYza7izc91+3y3up1M1y3xGQexxF/MKN6cjFscDJzCIjqJPXwLM86hmNqxlv1qVG15pHMeB2g/22bexAr6GGdkNW+E+CpL/DfBcmykVXiJNNTQFnySxyIzUc8/weC2C0VCfPUt7z2UqWE09KMUfx4NrWpJPOyo63HsoU4sZtKKKIziki60OfrZUY2LWC82+yC+5qeuClP8OqrAelqNDcTFPy3E19JKtg0ewLeyvVeUc1aQstWYnZwB43cmfiSnFW9ir4kIRZj4j5j4z/CBxxVl9hUI8fuE+LOJSt7E9Vct8c03FT+WqI4iopnil2OvPpooe8CaI2NuQe0smQqWPLjvLpkK0sQrscSPKcXbxZi5vZbKRbbqmXitXxwvc0GMGWrBch/F8xMNF99inuA4RoiJLxPiNwd7ZTEz6ntNcu/q12plKkgRz1EOYIwz6eniTbn2qEZ3lj9CCfHFDvFm/6wYnVL8IeiK9l82LKuSaVaS4p9NFR/rwF4hvjSreM/zduBJfEz/VYpP3ePzg4s/YYnPeSwpvkw7zTaF/G+cE9cbhPj1TvFyxdcx8Y36iCymk78DhXhOcsC/sLPkEttm+Bn+F/GvdS7711quX5HX80GKLzmV8cGqZpCdapqY+EaU0RtYGRyQ9fy+gIT4SiZ+ByLWL3kU3doTTPwKJr4OPS7Pof8jnZNFvL8IOa3dWGVb8X6TyxfwdTBxlOQnmhfFicY8SvIHKxPvss344UcpnuOn/FxkTCdcvOtRMph+WM31PrZPjjwj0zRcxfuB14mGG2oKZeqZ/rcW7JLptOD3wplS8dcKfkvnWOKvx3RHH/4DwAwSkwgsEUQAAAAASUVORK5CYII='

def gentimestamps
  DateTime.now.strftime('%Q')
end
def gensign(skey, timestamps)
  Digest::MD5.hexdigest(skey + timestamps)
end

uri = URI(jduri)
tmst = gentimestamps
puts tmst
signkey = gensign(skey, tmst)
params = {'timestamp' => tmst, 'sign' => signkey, 'appkey' => appkey}
puts params
uri.query = URI.encode_www_form(params)
puts uri
data = {'imageBase64Str' => imgbase64}.to_json
req = Net::HTTP::Post.new(uri)
req.set_content_type('application/json')
req.set_body_internal(data)
# req.set_form_data('from' => '2005-01-01', 'to' => '2005-03-31')

res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
  http.request(req)
end

case res
when Net::HTTPSuccess, Net::HTTPRedirection
  # OK
  puts res.body
else
  res.value
end
