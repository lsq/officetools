require 'watir'
require 'pry'

## use pry -r ./filename.rb
profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = 'C:\Users\Administrator\Downloads'
profile['browser.download.folderList'] = 2
profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf'
browser = Watir::Browser.new :firefox, profile: profile
browser.goto ' https://up.woozooo.com/account.php?action=login&ref=/mydisk.php'
Watir::Wait.until { browser.text_field(id: "username").present? }
browser.text_field(name: 'username').exists?
username = browser.text_field(name: 'username')
username.set('13113602265')
browser.text_field(name: 'password').exists?
password = browser.text_field(name: 'password')
password.set('比')
browser.element(id:'s3').exists?
button = browser.element(id:'s3')
button.click

binding.pry
puts "finished !"