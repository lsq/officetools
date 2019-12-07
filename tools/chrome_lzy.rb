require 'watir'
require 'watir/extensions/element/screenshot'
require 'pry'

## use pry -r ./filename.rb
#Selenium::WebDriver.logger.level = :debug
# https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings
#profile = Selenium::WebDriver::Firefox::Profile.new
#capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
#capabilities['firefox.page.customHeaders.Accept-Language'] = 'zh-CN,zh;q=0.9'
#profile.add_extension('./headereditor.xpi')
##profile['browser.download.dir'] = 'C:\Users\Administrator\Downloads'
#profile['browser.download.dir'] = './'
#profile['browser.download.folderList'] = 2
##profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf'
#profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/zip'
#browser = Watir::Browser.new :firefox, profile: profile, desired_capabilities: capabilities
#browser = Watir::Browser.new :firefox, profile: 'default-release' 
#options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless', "-profile", "/home/lsq/.mozilla/firefox/3hxb38kg.lsq"])
# options = Selenium::WebDriver::Firefox::Options.new(args: ["-profile", "/home/lsq/.mozilla/firefox/3hxb38kg.lsq"])
# browser = Watir::Browser.new :firefox, options: options
#args = %W[--user-data-dir=C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\User\ Data\\Default]
######## test in windows and linux  +++++++
######## but must just have one sesion use user data-dir
args = %W[--user-data-dir=C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\User\ Data]
## on linux 
# args = %W[--user-data-dir=/home/lsq/.config/chromium]
# switches = %W[--user-data-dir=/chrome]  => Linux or Mac


prefs = {
  :download => {
    :prompt_for_download => false,
    :default_directory => "c:\\downloads"
  }
}

browser = Watir::Browser.new :chrome, options: {prefs: prefs, args: args}
################
# browser = Watir::Browser.new :firefox, profile: 'lsq' 
browser.goto 'https://up.woozooo.com/account.php?action=login&ref=/mydisk.php'
#
#Watir::Wait.until { browser.text_field(id: "username").present? }
browser.text_field(name: 'username').exists?
username = browser.text_field(name: 'username')
username.set('13113602265')
browser.text_field(name: 'password').exists?
password = browser.text_field(name: 'password')
password.set('lsq1213LAN')
browser.element(id:'s3').exists?
button = browser.element(id:'s3')
button.click

#browser.div(class: 'imcode').screenshot('readme.png')
#browser.div(class: 'imcode').exists?
binding.pry
puts "finished !"