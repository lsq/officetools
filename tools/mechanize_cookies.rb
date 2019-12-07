
#https://qiita.com/yujiG/items/955c9e161e44c9946bd0
require 'mechanize'
require 'selenium-webdriver'
require 'net/http'

gmail = 'https://mail.google.com/'
MAIL = '<メアド>@gmail.com'
PASS = '<パスワード>'

def request_mail(cookie)
  uri = URI.parse("<頑張ってPOST用のURL見つけてね>")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/x-www-form-urlencoded;charset=UTF-8"
  request["X-Same-Domain"] = "1"
  request["Origin"] = "https://mail.google.com"
  request["Accept-Language"] = "ja,en-US;q=0.9,en;q=0.8,pt;q=0.7"
  request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36"
  request["Accept"] = "*/*"
  request["Authority"] = "mail.google.com"
  request["Content-Length"] = "0"
  request["Cookie"] = cookie
  null = nil
  response = Net::HTTP.start(uri.hostname, uri.port, {use_ssl: uri.scheme == "https"}) do |http|
    http.request(request)
  end
  # 適当にParseしてるから、おかしかったら書き換えて
  eval(response.body.force_encoding("UTF-8").gsub(")]}'\n\n", ''))
end

def login_selenium(driver)
  sleep(1)
  driver.find_element(:name, 'identifier').send_key(MAIL)
  driver.find_element(:id, 'identifierNext').click
  sleep(1)
  driver.find_element(:name, 'password').send_key(PASS)
  driver.find_element(:id, 'passwordNext').click
  driver
end

class CookieParser
  def selenium_to_mechanize(driver, agent)
    driver.manage.all_cookies.each do |cookie|
      agent.cookie_jar << Mechanize::Cookie.new(cookie[:name], cookie[:domain], {:value => cookie[:value], :domain => cookie[:domain], :path => cookie[:path]})
    end
    agent
  end

  def mechanizes_to_nethttp(agent)
    cookie_str = ''
    agent.cookie_jar.to_a.each do |cookie|
      cookie_str += cookie.to_s + '; '
    end
    cookie_str
  end
end

agent = Mechanize.new
driver = Selenium::WebDriver.for :chrome
driver.navigate.to(gmail)

driver = login_selenium(driver)
sleep(3)

# SeleniumのCookieを取得
selenium_cookie = driver.manage.all_cookies
# puts selenium_cookie

cookie_parser = CookieParser.new

# seleniumのCookieをMechanizeに渡す
agent = cookie_parser.selenium_to_mechanize(driver, agent)

# mechanizeのCookieを取得
mechanize_cookie = agent.cookie_jar
# puts mechanize_cookie

# MechanizeのCookieをNet/HTTPに渡す
puts request_mail(cookie_parser.mechanizes_to_nethttp(agent))