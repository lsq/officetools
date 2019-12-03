#!/usr/bin/env ruby -w
# encoding: utf-8

require 'watir'


profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = 'C:\Users\Administrator\Downloads'
profile['browser.download.folderList'] = 2
profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf'
browser = Watir::Browser.new :firefox, profile: profile

#browser.goto 'http://www.lanzou.com/u'
browser.goto 'https://up.woozooo.com/account.php?action=login&ref=/mydisk.php'
# browser.link(text: 'Guides').click

puts browser.title
# => 'Guides – Watir Project'
# browser.close
username = browser.text_field(id: 'username') if browser.text_field(name: 'username').exists?
# username.exists?
username.set '13113602665'
password = browser.text_field(name: 'password') if password = browser.text_field(name: 'password').exists?
password.set('xx')
#button = browser.element(id:'s3')
browser.element(id:'s3').click
#username.value
# https://blog.csdn.net/weixin_34209406/article/details/90122639
# 在 Watir 的 Wiki 上, Watir 中识别各种 HTML 对象
